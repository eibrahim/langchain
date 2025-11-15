# frozen_string_literal: true

# This example demonstrates basic usage of LangChain Ruby
# with a simple echo LLM for demonstration purposes.

require_relative '../lib/langchain_rb'

# Create a simple echo LLM for demonstration
class EchoLLM < LangchainRb::LanguageModels::LLM
  protected

  def _generate(prompt, stop: nil) # rubocop:disable Lint/UnusedMethodArgument
    "Echo: #{prompt}"
  end
end

# Example 1: Basic LLM usage
puts '=== Example 1: Basic LLM Usage ==='
llm = EchoLLM.new(model_name: 'echo-v1')
response = llm.call('Hello, world!')
puts response
puts

# Example 2: Prompt Template
puts '=== Example 2: Prompt Template ==='
template = LangchainRb::Prompts::PromptTemplate.from_template(
  'Tell me a {adjective} joke about {content}.'
)
prompt = template.format(adjective: 'funny', content: 'programming')
puts "Formatted prompt: #{prompt}"
puts

# Example 3: LLM Chain
puts '=== Example 3: LLM Chain ==='
chain = LangchainRb::Chains::LLMChain.new(
  llm: llm,
  prompt: template,
  verbose: true
)
result = chain.predict(adjective: 'hilarious', content: 'Ruby')
puts "Result: #{result}"
puts

# Example 4: Chat Prompt Template
puts '=== Example 4: Chat Prompt Template ==='
chat_template = LangchainRb::Prompts::ChatPromptTemplate.from_messages([
                                                                         [:system, 'You are a helpful AI assistant.'],
                                                                         [:human, 'What is {topic}?'],
                                                                         [:ai, 'Let me explain {topic} to you.'],
                                                                         [:human, '{question}']
                                                                       ])

messages = chat_template.format_messages(
  topic: 'Ruby programming',
  question: 'Can you give me an example?'
)

puts 'Formatted messages:'
messages.each { |msg| puts "  #{msg}" }
puts

# Example 5: Memory
puts '=== Example 5: Memory ==='
memory = LangchainRb::Memory::BufferMemory.new

# Manually save some context
memory.save_context(
  { input: 'Hi, my name is Alice' },
  { text: 'Hello Alice! Nice to meet you.' }
)
memory.save_context(
  { input: "What's my name?" },
  { text: 'Your name is Alice.' }
)

puts 'Memory buffer:'
puts memory.buffer_as_str
puts

# Example 6: Chain with Memory
puts '=== Example 6: Chain with Memory ==='
memory = LangchainRb::Memory::BufferMemory.new
conversation_prompt = LangchainRb::Prompts::PromptTemplate.from_template(
  "Conversation history:\n{history}\n\nHuman: {input}\nAI:"
)

conversation_chain = LangchainRb::Chains::LLMChain.new(
  llm: llm,
  prompt: conversation_prompt,
  memory: memory
)

# First turn
response1 = conversation_chain.call(input: 'Hi there!')
puts "Turn 1: #{response1[:text]}"

# Second turn
response2 = conversation_chain.call(input: 'What did I just say?')
puts "Turn 2: #{response2[:text]}"

puts "\nFull conversation history:"
puts memory.buffer_as_str
puts

puts '=== All Examples Completed ==='
