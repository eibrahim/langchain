# Azure OpenAI Integration Guide

This guide explains how to use the Azure OpenAI provider integration in LangChain Ruby.

## Overview

The Azure OpenAI integration provides full support for Azure OpenAI Service, including both chat completions and text completions.

## Features

- ✅ Chat completions via `LangchainRb::Providers::AzureOpenAI::Chat`
- ✅ Text completions via `LangchainRb::Providers::AzureOpenAI::LLM`
- ✅ Configurable endpoints, API versions, and deployment names
- ✅ Support for temperature, max_tokens, and stop sequences
- ✅ Proper error handling and validation
- ✅ Full test coverage (16 tests)

## Prerequisites

1. An Azure account with an Azure OpenAI resource
2. A deployed model in Azure OpenAI (e.g., GPT-4, GPT-3.5-Turbo)
3. Your Azure OpenAI credentials:
   - API key
   - Endpoint URL
   - Deployment name

## Installation

Add to your Gemfile:

```ruby
gem 'langchain_rb'
```

Then run:

```bash
bundle install
```

## Quick Start

### Chat Completions

```ruby
require 'langchain_rb'

# Initialize the chat model
chat = LangchainRb::Providers::AzureOpenAI::Chat.new(
  api_key: ENV['AZURE_OPENAI_API_KEY'],
  endpoint: ENV['AZURE_OPENAI_ENDPOINT'],
  deployment_name: 'gpt-4',
  api_version: '2024-02-01',  # Optional, defaults to '2024-02-01'
  temperature: 0.7,            # Optional, defaults to 0.7
  max_tokens: 150              # Optional
)

# Create messages
messages = [
  LangchainRb::Messages::SystemMessage.new(
    content: 'You are a helpful AI assistant.'
  ),
  LangchainRb::Messages::HumanMessage.new(
    content: 'What is Ruby programming language?'
  )
]

# Get response
response = chat.call(messages)
puts response.content
```

### Text Completions

```ruby
require 'langchain_rb'

# Initialize the LLM model (for instruct models)
llm = LangchainRb::Providers::AzureOpenAI::LLM.new(
  api_key: ENV['AZURE_OPENAI_API_KEY'],
  endpoint: ENV['AZURE_OPENAI_ENDPOINT'],
  deployment_name: 'gpt-35-turbo-instruct',
  temperature: 0.5,
  max_tokens: 100
)

# Get completion
prompt = 'Explain what Azure OpenAI is in one sentence:'
completion = llm.call(prompt)
puts completion
```

## Configuration Options

### Required Parameters

- `api_key` (String) - Your Azure OpenAI API key
- `endpoint` (String) - Your Azure OpenAI endpoint (e.g., "https://your-resource.openai.azure.com")
- `deployment_name` (String) - Name of your deployment in Azure

### Optional Parameters

- `api_version` (String) - API version to use (default: '2024-02-01')
- `temperature` (Float) - Sampling temperature 0.0 to 2.0 (default: 0.7)
- `max_tokens` (Integer) - Maximum tokens to generate (default: nil)
- `callbacks` (Array) - Callbacks for monitoring (default: nil)
- `streaming` (Boolean) - Enable streaming support for LLM (default: false)

## Using with Chains

You can use Azure OpenAI models with LangChain chains:

```ruby
# Create a prompt template
template = LangchainRb::Prompts::ChatPromptTemplate.from_messages([
  [:system, 'You are an expert in {topic}.'],
  [:human, '{question}']
])

# Format messages
messages = template.format_messages(
  topic: 'cloud computing',
  question: 'What are the benefits of Azure?'
)

# Use with chat model
chat = LangchainRb::Providers::AzureOpenAI::Chat.new(
  api_key: ENV['AZURE_OPENAI_API_KEY'],
  endpoint: ENV['AZURE_OPENAI_ENDPOINT'],
  deployment_name: 'gpt-4'
)

response = chat.call(messages)
puts response.content
```

## Environment Variables

Best practice is to use environment variables for sensitive configuration:

```ruby
# .env file or environment
AZURE_OPENAI_API_KEY=your-api-key-here
AZURE_OPENAI_ENDPOINT=https://your-resource.openai.azure.com
AZURE_OPENAI_DEPLOYMENT=gpt-4

# In your code
chat = LangchainRb::Providers::AzureOpenAI::Chat.new(
  api_key: ENV['AZURE_OPENAI_API_KEY'],
  endpoint: ENV['AZURE_OPENAI_ENDPOINT'],
  deployment_name: ENV['AZURE_OPENAI_DEPLOYMENT']
)
```

## Error Handling

The Azure OpenAI provider includes comprehensive error handling:

```ruby
begin
  response = chat.call(messages)
  puts response.content
rescue LangchainRb::LLMError => e
  puts "API Error: #{e.message}"
  # Handle error appropriately
end
```

Common errors:
- `401` - Invalid API key
- `404` - Deployment not found
- `429` - Rate limit exceeded
- `500` - Server error

## Advanced Usage

### Using Stop Sequences

```ruby
response = chat.call(messages, stop: ["\n", "END"])
```

### With Memory

```ruby
memory = LangchainRb::Memory::BufferMemory.new

# Use memory with chains for conversation history
conversation_template = LangchainRb::Prompts::PromptTemplate.from_template(
  "History: {history}\n\nHuman: {input}\nAssistant:"
)

# Create chain with memory
chain = LangchainRb::Chains::LLMChain.new(
  llm: llm,
  prompt: conversation_template,
  memory: memory
)

# First turn
chain.call(input: "Hi there!")

# Second turn - includes history
chain.call(input: "What did I say?")
```

## API Compatibility

This integration uses the Azure OpenAI REST API and is compatible with:

- API Version: 2024-02-01 (default, configurable)
- All Azure OpenAI deployments
- Both chat and completion endpoints

## Limitations

- Streaming is not yet implemented (coming soon)
- Function calling support planned for future release

## Testing

Run the test suite:

```bash
bundle exec rspec spec/providers/azure_openai/
```

## Example Code

See `examples/azure_openai_usage.rb` for a comprehensive example demonstrating all features.

## Support

For issues or questions:
- Check the [main README](README.md) for general usage
- Review the [test suite](spec/providers/azure_openai/) for examples
- Open an issue on GitHub

## License

MIT License - See [LICENSE](LICENSE) file
