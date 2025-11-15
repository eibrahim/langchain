# frozen_string_literal: true

require_relative 'base'

module LangchainRb
  module LanguageModels
    # LLM class for text completion models.
    # Extends the base language model for completion-style interactions.
    class LLM < Base
      attr_reader :streaming

      def initialize(model_name:, temperature: 0.7, max_tokens: nil, streaming: false, callbacks: nil)
        super(model_name: model_name, temperature: temperature, max_tokens: max_tokens, callbacks: callbacks)
        @streaming = streaming
      end

      # Generate a completion from the LLM.
      #
      # @param prompt [String] The prompt to complete
      # @param stop [Array<String>] Optional stop sequences
      # @return [String] The completion text
      def call(prompt, stop: nil)
        run_before_callbacks(prompt)

        begin
          response = _generate(prompt, stop: stop)
          run_after_callbacks(response)
          response
        rescue StandardError => e
          run_error_callbacks(e)
          raise LLMError, "Failed to generate completion: #{e.message}"
        end
      end

      # Stream a completion from the LLM.
      # Yields chunks of text as they are generated.
      #
      # @param prompt [String] The prompt to complete
      # @param stop [Array<String>] Optional stop sequences
      # @yield [String] Chunks of generated text
      def stream(prompt, stop: nil, &block)
        raise NotImplementedError, 'Streaming not implemented for this model' unless streaming

        _stream(prompt, stop: stop, &block)
      end

      protected

      # Generate a completion. Must be implemented by subclasses.
      #
      # @param prompt [String] The prompt to complete
      # @param stop [Array<String>] Optional stop sequences
      # @return [String] The completion text
      def _generate(prompt, stop: nil)
        raise NotImplementedError, "Subclasses must implement the '_generate' method"
      end

      # Stream a completion. Should be implemented by subclasses that support streaming.
      #
      # @param prompt [String] The prompt to complete
      # @param stop [Array<String>] Optional stop sequences
      # @yield [String] Chunks of generated text
      def _stream(prompt, stop: nil)
        raise NotImplementedError, "Subclasses must implement the '_stream' method"
      end
    end
  end
end
