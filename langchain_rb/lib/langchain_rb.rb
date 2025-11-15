# frozen_string_literal: true

require_relative 'langchain_rb/version'
require_relative 'langchain_rb/exceptions'
require_relative 'langchain_rb/language_models/base'
require_relative 'langchain_rb/language_models/llm'
require_relative 'langchain_rb/language_models/chat_model'
require_relative 'langchain_rb/prompts/base'
require_relative 'langchain_rb/prompts/prompt_template'
require_relative 'langchain_rb/prompts/chat_prompt_template'
require_relative 'langchain_rb/chains/base'
require_relative 'langchain_rb/chains/llm_chain'
require_relative 'langchain_rb/memory/base'
require_relative 'langchain_rb/memory/buffer_memory'
require_relative 'langchain_rb/output_parsers/base'
require_relative 'langchain_rb/output_parsers/string_parser'
require_relative 'langchain_rb/messages/base'
require_relative 'langchain_rb/messages/human_message'
require_relative 'langchain_rb/messages/ai_message'
require_relative 'langchain_rb/messages/system_message'
require_relative 'langchain_rb/providers/azure_openai'

module LangchainRb
  class Error < StandardError; end

  # Configuration class for global settings
  class Configuration
    attr_accessor :verbose

    def initialize
      @verbose = false
    end
  end

  class << self
    attr_writer :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end

    def reset_configuration!
      @configuration = Configuration.new
    end
  end
end
