# frozen_string_literal: true

module LangchainRb
  module LanguageModels
    # Base class for all language models in LangChain.
    # Defines the interface that all language models must implement.
    class Base
      attr_reader :model_name, :temperature, :max_tokens, :callbacks

      def initialize(model_name:, temperature: 0.7, max_tokens: nil, callbacks: nil)
        @model_name = model_name
        @temperature = temperature
        @max_tokens = max_tokens
        @callbacks = callbacks || []
      end

      # Generate a response from the language model.
      # Must be implemented by subclasses.
      #
      # @param prompt [String] The prompt to send to the model
      # @param stop [Array<String>] Optional stop sequences
      # @return [String] The generated response
      def call(prompt, stop: nil)
        raise NotImplementedError, "Subclasses must implement the 'call' method"
      end

      # Generate responses for multiple prompts.
      #
      # @param prompts [Array<String>] Array of prompts
      # @param stop [Array<String>] Optional stop sequences
      # @return [Array<String>] Array of generated responses
      def generate(prompts, stop: nil)
        prompts.map { |prompt| call(prompt, stop: stop) }
      end

      # Calculate the number of tokens in a text string.
      #
      # @param text [String] The text to tokenize
      # @return [Integer] The number of tokens
      def get_num_tokens(text)
        # Simple approximation: split by whitespace
        # Subclasses should override with model-specific tokenization
        text.split.length
      end

      # Get identifying parameters for the language model.
      #
      # @return [Hash] Hash of model parameters
      def identifying_params
        {
          model_name: model_name,
          temperature: temperature,
          max_tokens: max_tokens
        }
      end

      private

      # Execute callbacks before generation
      def run_before_callbacks(prompt)
        callbacks.each { |callback| callback.on_llm_start(prompt) if callback.respond_to?(:on_llm_start) }
      end

      # Execute callbacks after generation
      def run_after_callbacks(response)
        callbacks.each { |callback| callback.on_llm_end(response) if callback.respond_to?(:on_llm_end) }
      end

      # Execute callbacks on error
      def run_error_callbacks(error)
        callbacks.each { |callback| callback.on_llm_error(error) if callback.respond_to?(:on_llm_error) }
      end
    end
  end
end
