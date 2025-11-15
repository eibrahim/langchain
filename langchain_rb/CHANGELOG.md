# Changelog

All notable changes to the LangChain Ruby gem will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2024-11-15

### Added
- Initial release of LangChain Ruby gem
- Core abstractions for language models:
  - `LangchainRb::LanguageModels::Base` - Base class for all language models
  - `LangchainRb::LanguageModels::LLM` - Text completion models
  - `LangchainRb::LanguageModels::ChatModel` - Conversational models
- Prompt template system:
  - `LangchainRb::Prompts::PromptTemplate` - String templates with variable substitution
  - `LangchainRb::Prompts::ChatPromptTemplate` - Chat message templates
- Chain composition:
  - `LangchainRb::Chains::Base` - Base class for chains
  - `LangchainRb::Chains::LLMChain` - LLM + Prompt chain
- Memory management:
  - `LangchainRb::Memory::Base` - Base class for memory
  - `LangchainRb::Memory::BufferMemory` - Conversation buffer memory
- Message types:
  - `LangchainRb::Messages::HumanMessage` - User messages
  - `LangchainRb::Messages::AIMessage` - AI responses
  - `LangchainRb::Messages::SystemMessage` - System context
- Output parsers:
  - `LangchainRb::OutputParsers::Base` - Base class for parsers
  - `LangchainRb::OutputParsers::StringParser` - Simple string parser
- Comprehensive RSpec test suite (32 tests)
- Working examples demonstrating all features
- Complete documentation with usage examples
- RuboCop configuration for code quality

[0.1.0]: https://github.com/langchain-ai/langchain/releases/tag/v0.1.0
