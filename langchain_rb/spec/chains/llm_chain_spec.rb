# frozen_string_literal: true

# Simple test LLM for use in specs
class TestLLM < LangchainRb::LanguageModels::LLM
  attr_reader :call_count
  attr_writer :response

  def initialize(**kwargs)
    super
    @call_count = 0
    @response = 'Test response'
  end

  protected

  def _generate(_prompt, stop: nil) # rubocop:disable Lint/UnusedMethodArgument
    @call_count += 1
    @response
  end
end

RSpec.describe LangchainRb::Chains::LLMChain do
  let(:llm) { TestLLM.new(model_name: 'test') }
  let(:prompt) do
    LangchainRb::Prompts::PromptTemplate.from_template('Question: {question}')
  end
  let(:chain) { described_class.new(llm: llm, prompt: prompt) }

  describe '#initialize' do
    it 'sets llm and prompt' do
      expect(chain.llm).to eq(llm)
      expect(chain.prompt).to eq(prompt)
    end
  end

  describe '#input_keys' do
    it 'returns prompt input variables' do
      expect(chain.input_keys).to eq([:question])
    end
  end

  describe '#output_keys' do
    it 'returns text key' do
      expect(chain.output_keys).to eq([:text])
    end
  end

  describe '#call' do
    it 'executes the chain and returns output' do
      llm.response = 'Paris'
      result = chain.call(question: 'What is the capital of France?')

      expect(result[:text]).to eq('Paris')
      expect(llm.call_count).to eq(1)
    end
  end

  describe '#predict' do
    it 'returns just the text output' do
      llm.response = '42'
      result = chain.predict(question: 'What is the answer?')

      expect(result).to eq('42')
    end
  end

  describe 'with memory' do
    let(:memory) { LangchainRb::Memory::BufferMemory.new }
    let(:prompt_with_history) do
      LangchainRb::Prompts::PromptTemplate.from_template(
        'History: {history}\nQuestion: {input}'
      )
    end
    let(:chain_with_memory) do
      described_class.new(llm: llm, prompt: prompt_with_history, memory: memory)
    end

    it 'loads and saves memory context' do
      llm.response = 'First response'
      chain_with_memory.call(input: 'First question')

      llm.response = 'Second response'
      chain_with_memory.call(input: 'Second question')

      buffer = memory.buffer_as_str
      expect(buffer).to include('First question')
      expect(buffer).to include('First response')
      expect(buffer).to include('Second question')
      expect(buffer).to include('Second response')
    end
  end
end
