# frozen_string_literal: true

# This example demonstrates how to use Azure OpenAI with LangChain Ruby
# You'll need to set up Azure OpenAI service and have the following:
# - API key
# - Endpoint URL
# - Deployment name

require_relative '../lib/langchain_rb'

# Configuration - replace these with your actual Azure OpenAI values
API_KEY = ENV.fetch('AZURE_OPENAI_API_KEY', 'your-api-key-here')
ENDPOINT = ENV.fetch('AZURE_OPENAI_ENDPOINT', 'https://your-resource.openai.azure.com')
DEPLOYMENT_NAME = ENV.fetch('AZURE_OPENAI_DEPLOYMENT', 'gpt-4')

# Example 1: Basic Chat with Azure OpenAI
puts '=== Example 1: Basic Chat with Azure OpenAI ==='

LangchainRb::Providers::AzureOpenAI::Chat.new(
  api_key: API_KEY,
  endpoint: ENDPOINT,
  deployment_name: DEPLOYMENT_NAME,
  temperature: 0.7,
  max_tokens: 150
)

# Create messages
[
  LangchainRb::Messages::SystemMessage.new(content: 'You are a helpful AI assistant.'),
  LangchainRb::Messages::HumanMessage.new(content: 'What is Ruby programming language?')
]

# Get response (commented out to avoid actual API calls in example)
# response = chat_model.call(messages)
# puts "AI: #{response.content}"
puts 'Chat model created successfully!'
puts

# Example 2: Using Azure OpenAI with Chains
puts '=== Example 2: Using Azure OpenAI with Chains ==='

# Create a prompt template
template = LangchainRb::Prompts::ChatPromptTemplate.from_messages([
                                                                    [:system, 'You are an expert in {topic}.'],
                                                                    [:human, '{question}']
                                                                  ])

# Create messages with the template
messages = template.format_messages(
  topic: 'Ruby programming',
  question: 'What are the main features of Ruby?'
)

puts 'Template formatted successfully!'
puts "Messages: #{messages.map(&:to_s).join("\n")}"
puts

# Example 3: Using Azure OpenAI LLM (Completions)
puts '=== Example 3: Using Azure OpenAI LLM (Completions) ==='

LangchainRb::Providers::AzureOpenAI::LLM.new(
  api_key: API_KEY,
  endpoint: ENDPOINT,
  deployment_name: 'gpt-35-turbo-instruct', # Use an instruct model for completions
  temperature: 0.5,
  max_tokens: 100
)

# Get completion (commented out to avoid actual API calls in example)
# completion = llm.call(prompt)
# puts "Completion: #{completion}"
puts 'LLM model created successfully!'
puts

# Example 4: Using Azure OpenAI with LLMChain and Memory
puts '=== Example 4: Using Azure OpenAI with LLMChain and Memory ==='

# Create memory for conversation history
LangchainRb::Memory::BufferMemory.new

# Create a prompt template that uses history
LangchainRb::Prompts::PromptTemplate.from_template(
  "Conversation history:\n{history}\n\nHuman: {input}\nAssistant:"
)

# NOTE: For this to work with chat models, you'd typically create a custom chain
# or use the chat_prompt_template directly
puts 'Memory and template created successfully!'
puts

# Example 5: Handling Different Message Types
puts '=== Example 5: Handling Different Message Types ==='

conversation = [
  LangchainRb::Messages::SystemMessage.new(
    content: 'You are a knowledgeable assistant specializing in cloud computing.'
  ),
  LangchainRb::Messages::HumanMessage.new(
    content: 'What are the benefits of using Azure?'
  ),
  LangchainRb::Messages::AIMessage.new(
    content: 'Azure offers scalability, security, and global reach.'
  ),
  LangchainRb::Messages::HumanMessage.new(
    content: 'Tell me more about security features.'
  )
]

puts 'Multi-turn conversation created:'
conversation.each { |msg| puts "  #{msg}" }
puts

# Example 6: Configuration with Environment Variables
puts '=== Example 6: Best Practices for Configuration ==='

# Always use environment variables for sensitive data
puts 'Configuration checklist:'
puts '  ✓ API key from environment variable'
puts '  ✓ Endpoint URL from environment variable'
puts '  ✓ Deployment name configurable'
puts '  ✓ Temperature and max_tokens customizable'
puts

puts '=== All Examples Completed ==='
puts
puts 'Note: To actually make API calls, you need to:'
puts '1. Set up an Azure OpenAI resource in Azure Portal'
puts '2. Deploy a model (e.g., GPT-4, GPT-3.5-Turbo)'
puts '3. Set environment variables:'
puts '   - AZURE_OPENAI_API_KEY'
puts '   - AZURE_OPENAI_ENDPOINT'
puts '   - AZURE_OPENAI_DEPLOYMENT'
puts '4. Uncomment the API call lines in this example'
