# frozen_string_literal: true

require 'webmock/rspec'

RSpec.describe LangchainRb::Providers::AzureOpenAI::Chat do
  let(:api_key) { 'test-api-key' }
  let(:endpoint) { 'https://test-resource.openai.azure.com' }
  let(:deployment_name) { 'gpt-4' }
  let(:api_version) { '2024-02-01' }

  let(:chat_model) do
    described_class.new(
      api_key: api_key,
      endpoint: endpoint,
      deployment_name: deployment_name,
      api_version: api_version,
      temperature: 0.7,
      max_tokens: 100
    )
  end

  describe '#initialize' do
    it 'sets the configuration correctly' do
      expect(chat_model.api_key).to eq(api_key)
      expect(chat_model.endpoint).to eq(endpoint)
      expect(chat_model.deployment_name).to eq(deployment_name)
      expect(chat_model.api_version).to eq(api_version)
      expect(chat_model.model_name).to eq(deployment_name)
      expect(chat_model.temperature).to eq(0.7)
      expect(chat_model.max_tokens).to eq(100)
    end

    it 'strips trailing slash from endpoint' do
      model = described_class.new(
        api_key: api_key,
        endpoint: 'https://test-resource.openai.azure.com/',
        deployment_name: deployment_name
      )
      expect(model.endpoint).to eq('https://test-resource.openai.azure.com')
    end
  end

  describe '#call' do
    let(:messages) do
      [
        LangchainRb::Messages::SystemMessage.new(content: 'You are a helpful assistant.'),
        LangchainRb::Messages::HumanMessage.new(content: 'Hello!')
      ]
    end

    let(:expected_url) do
      "#{endpoint}/openai/deployments/#{deployment_name}/chat/completions?api-version=#{api_version}"
    end

    let(:response_body) do
      {
        'choices' => [
          {
            'message' => {
              'role' => 'assistant',
              'content' => 'Hello! How can I help you today?'
            }
          }
        ]
      }
    end

    before do
      stub_request(:post, expected_url)
        .with(
          headers: {
            'Content-Type' => 'application/json',
            'api-key' => api_key
          },
          body: hash_including(
            messages: [
              { role: 'system', content: 'You are a helpful assistant.' },
              { role: 'user', content: 'Hello!' }
            ],
            temperature: 0.7,
            max_tokens: 100
          )
        )
        .to_return(
          status: 200,
          body: response_body.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )
    end

    it 'makes a successful API call and returns an AI message' do
      result = chat_model.call(messages)

      expect(result).to be_a(LangchainRb::Messages::AIMessage)
      expect(result.content).to eq('Hello! How can I help you today?')
    end

    context 'with stop sequences' do
      before do
        stub_request(:post, expected_url)
          .with(
            body: hash_including(
              stop: ['\n', 'END']
            )
          )
          .to_return(
            status: 200,
            body: response_body.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )
      end

      it 'includes stop sequences in the request' do
        chat_model.call(messages, stop: ['\n', 'END'])
        expect(WebMock).to have_requested(:post, expected_url)
      end
    end

    context 'when API returns an error' do
      before do
        stub_request(:post, expected_url)
          .to_return(
            status: 401,
            body: { error: { message: 'Invalid API key' } }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )
      end

      it 'raises an LLMError' do
        expect { chat_model.call(messages) }
          .to raise_error(LangchainRb::LLMError, /Invalid API key/)
      end
    end

    context 'when response has no content' do
      before do
        stub_request(:post, expected_url)
          .to_return(
            status: 200,
            body: { choices: [{ message: {} }] }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )
      end

      it 'raises an LLMError' do
        expect { chat_model.call(messages) }
          .to raise_error(LangchainRb::LLMError, /No content in response/)
      end
    end
  end

  describe '#call_prompt' do
    let(:expected_url) do
      "#{endpoint}/openai/deployments/#{deployment_name}/chat/completions?api-version=#{api_version}"
    end

    let(:response_body) do
      {
        'choices' => [
          {
            'message' => {
              'role' => 'assistant',
              'content' => 'Hi there!'
            }
          }
        ]
      }
    end

    before do
      stub_request(:post, expected_url)
        .to_return(
          status: 200,
          body: response_body.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )
    end

    it 'wraps prompt in a HumanMessage and calls the API' do
      result = chat_model.call_prompt('Hello!')

      expect(result).to be_a(LangchainRb::Messages::AIMessage)
      expect(result.content).to eq('Hi there!')
    end
  end

  describe '#stream' do
    let(:messages) do
      [LangchainRb::Messages::HumanMessage.new(content: 'Hello!')]
    end

    it 'raises NotImplementedError' do
      expect { chat_model.stream(messages) }
        .to raise_error(NotImplementedError, /Streaming not yet implemented/)
    end
  end
end
