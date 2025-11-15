# frozen_string_literal: true

RSpec.describe LangchainRb::Prompts::PromptTemplate do
  describe '.from_template' do
    it 'creates a template with detected variables' do
      template = described_class.from_template('Hello {name}, you are {age} years old.')
      expect(template.input_variables).to contain_exactly(:name, :age)
    end

    it 'handles templates with no variables' do
      template = described_class.from_template('Hello, world!')
      expect(template.input_variables).to be_empty
    end
  end

  describe '#format' do
    let(:template) do
      described_class.new(
        template: 'Tell me a {adjective} joke about {content}.',
        input_variables: %i[adjective content]
      )
    end

    it 'formats the template with provided variables' do
      result = template.format(adjective: 'funny', content: 'programming')
      expect(result).to eq('Tell me a funny joke about programming.')
    end

    it 'raises an error when required variables are missing' do
      expect { template.format(adjective: 'funny') }
        .to raise_error(LangchainRb::PromptError, /Missing required input variables: content/)
    end

    it 'handles extra variables gracefully' do
      result = template.format(adjective: 'funny', content: 'programming', extra: 'ignored')
      expect(result).to eq('Tell me a funny joke about programming.')
    end
  end
end
