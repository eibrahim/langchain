# LangChain Ruby

LangChain Ruby is a Ruby implementation of the LangChain framework for building applications powered by language models. It provides abstractions for language models, prompts, chains, memory, and more.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'langchain_rb'
```

And then execute:

```bash
bundle install
```

Or install it yourself as:

```bash
gem install langchain_rb
```

## Quick Start

### Basic LLM Usage

```ruby
require 'langchain_rb'

# Create a simple LLM (you'll need to implement or use a provider)
class SimpleEchoLLM < LangchainRb::LanguageModels::LLM
  protected
  
  def _generate(prompt, stop: nil)
    "Echo: #{prompt}"
  end
end

llm = SimpleEchoLLM.new(model_name: "echo")
response = llm.call("Hello, world!")
puts response
# => "Echo: Hello, world!"
```

### Using Prompt Templates

```ruby
require 'langchain_rb'

# Create a prompt template
template = LangchainRb::Prompts::PromptTemplate.from_template(
  "Tell me a {adjective} joke about {content}."
)

# Format the template
prompt = template.format(adjective: "funny", content: "programming")
puts prompt
# => "Tell me a funny joke about programming."
```

### Chat Prompts

```ruby
require 'langchain_rb'

# Create a chat prompt template
chat_template = LangchainRb::Prompts::ChatPromptTemplate.from_messages([
  [:system, "You are a helpful assistant that translates {input_language} to {output_language}."],
  [:human, "{text}"]
])

# Format the messages
messages = chat_template.format_messages(
  input_language: "English",
  output_language: "French",
  text: "Hello, how are you?"
)

messages.each { |msg| puts msg }
# => system: You are a helpful assistant that translates English to French.
# => human: Hello, how are you?
```

### Using Chains

```ruby
require 'langchain_rb'

# Create an LLM and prompt template
llm = SimpleEchoLLM.new(model_name: "echo")
prompt = LangchainRb::Prompts::PromptTemplate.from_template(
  "What is a good name for a company that makes {product}?"
)

# Create a chain
chain = LangchainRb::Chains::LLMChain.new(llm: llm, prompt: prompt)

# Run the chain
result = chain.predict(product: "colorful socks")
puts result
```

### Using Memory

```ruby
require 'langchain_rb'

# Create memory
memory = LangchainRb::Memory::BufferMemory.new

# Create a chain with memory
llm = SimpleEchoLLM.new(model_name: "echo")
prompt = LangchainRb::Prompts::PromptTemplate.from_template(
  "Current conversation:\n{history}\n\nHuman: {input}\nAI:"
)

chain = LangchainRb::Chains::LLMChain.new(
  llm: llm,
  prompt: prompt,
  memory: memory
)

# First interaction
chain.call(input: "Hi there!")

# Second interaction - memory will include first interaction
chain.call(input: "What did I just say?")

# View memory
puts memory.buffer_as_str
```

## Core Concepts

### Language Models

LangChain Ruby provides base classes for different types of language models:

- `LangchainRb::LanguageModels::LLM` - For text completion models
- `LangchainRb::LanguageModels::ChatModel` - For chat/conversational models

To integrate with a specific provider (OpenAI, Anthropic, etc.), create a subclass and implement the required methods.

### Prompts

Prompts help you create and manage templates for LLM inputs:

- `LangchainRb::Prompts::PromptTemplate` - Simple string templates with variable substitution
- `LangchainRb::Prompts::ChatPromptTemplate` - Templates for chat messages

### Chains

Chains combine multiple components together:

- `LangchainRb::Chains::LLMChain` - Combines a prompt template and an LLM
- Create custom chains by extending `LangchainRb::Chains::Base`

### Memory

Memory persists state between chain calls:

- `LangchainRb::Memory::BufferMemory` - Stores conversation history in a buffer

### Messages

Different message types for conversations:

- `LangchainRb::Messages::HumanMessage` - User messages
- `LangchainRb::Messages::AIMessage` - AI responses
- `LangchainRb::Messages::SystemMessage` - System context messages

## Architecture

LangChain Ruby follows the same architectural patterns as the Python LangChain library:

1. **Modularity** - Components can be used independently or composed together
2. **Extensibility** - Base classes make it easy to add new integrations
3. **Type Safety** - Proper Ruby idioms and clear interfaces
4. **Testability** - Components are designed to be easily testable

## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/langchain-ai/langchain.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Related Projects

- [LangChain (Python)](https://github.com/langchain-ai/langchain) - The original Python implementation
- [LangChain.js](https://github.com/langchain-ai/langchainjs) - JavaScript/TypeScript implementation
