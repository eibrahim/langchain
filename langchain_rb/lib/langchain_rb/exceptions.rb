# frozen_string_literal: true

module LangchainRb
  # Base exception for all LangChain errors
  class LangchainError < StandardError; end

  # Raised when a language model call fails
  class LLMError < LangchainError; end

  # Raised when prompt validation fails
  class PromptError < LangchainError; end

  # Raised when chain execution fails
  class ChainError < LangchainError; end

  # Raised when memory operation fails
  class MemoryError < LangchainError; end

  # Raised when output parsing fails
  class OutputParserError < LangchainError; end

  # Raised when configuration is invalid
  class ConfigurationError < LangchainError; end

  # Raised when a required parameter is missing
  class MissingParameterError < LangchainError; end

  # Raised when authentication fails
  class AuthenticationError < LangchainError; end
end
