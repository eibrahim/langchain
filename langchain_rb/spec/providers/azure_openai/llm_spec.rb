# frozen_string_literal: true

require 'webmock/rspec'

RSpec.describe LangchainRb::Providers::AzureOpenAI::LLM do
  let(:api_key) { 'test-api-key' }
  let(:endpoint) { 'https://test-resource.openai.azure.com' }
  let(:deployment_name) { 'gpt-35-turbo-instruct' }
  let(:api_version) { '2024-02-01' }

  let(:llm) do
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
      expect(llm.api_key).to eq(api_key)
      expect(llm.endpoint).to eq(endpoint)
      expect(llm.deployment_name).to eq(deployment_name)
      expect(llm.api_version).to eq(api_version)
      expect(llm.model_name).to eq(deployment_name)
      expect(llm.temperature).to eq(0.7)
      expect(llm.max_tokens).to eq(100)
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
    let(:prompt) { 'Tell me a joke.' }

    let(:expected_url) do
      "#{endpoint}/openai/deployments/#{deployment_name}/completions?api-version=#{api_version}"
    end

    let(:response_body) do
      {
        'choices' => [
          {
            'text' => 'Why did the programmer quit his job? Because he didn\'t get arrays!'
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
            prompt: prompt,
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

    it 'makes a successful API call and returns text' do
      result = llm.call(prompt)

      expect(result).to be_a(String)
      expect(result).to include('programmer')
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
        llm.call(prompt, stop: ['\n', 'END'])
        expect(WebMock).to have_requested(:post, expected_url)
      end
    end

    context 'when API returns an error' do
      before do
        stub_request(:post, expected_url)
          .to_return(
            status: 429,
            body: { error: { message: 'Rate limit exceeded' } }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )
      end

      it 'raises an LLMError' do
        expect { llm.call(prompt) }
          .to raise_error(LangchainRb::LLMError, /Rate limit exceeded/)
      end
    end

    context 'when response has no text' do
      before do
        stub_request(:post, expected_url)
          .to_return(
            status: 200,
            body: { choices: [{}] }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )
      end

      it 'raises an LLMError' do
        expect { llm.call(prompt) }
          .to raise_error(LangchainRb::LLMError, /No text in response/)
      end
    end
  end

  describe '#stream' do
    let(:prompt) { 'Tell me a story.' }

    context 'when streaming is not enabled' do
      it 'raises NotImplementedError from parent class' do
        expect { llm.stream(prompt) {} }
          .to raise_error(NotImplementedError, /Streaming not implemented for this model/)
      end
    end

    context 'when streaming is enabled' do
      let(:llm) do
        described_class.new(
          api_key: api_key,
          endpoint: endpoint,
          deployment_name: deployment_name,
          streaming: true
        )
      end

      it 'raises NotImplementedError for Azure-specific streaming' do
        expect { llm.stream(prompt) {} }
          .to raise_error(NotImplementedError, /Streaming not yet implemented/)
      end
    end
  end
end
