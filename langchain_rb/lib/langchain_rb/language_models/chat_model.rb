# frozen_string_literal: true

require_relative 'base'

module LangchainRb
  module LanguageModels
    # ChatModel class for conversational language models.
    # Extends the base language model for chat-style interactions.
    class ChatModel < Base
      # Generate a response from the chat model.
      #
      # @param messages [Array<Message>] Array of message objects
      # @param stop [Array<String>] Optional stop sequences
      # @return [Message] The AI's response message
      def call(messages, stop: nil)
        run_before_callbacks(messages)

        begin
          response = _generate(messages, stop: stop)
          run_after_callbacks(response)
          response
        rescue StandardError => e
          run_error_callbacks(e)
          raise LLMError, "Failed to generate chat response: #{e.message}"
        end
      end

      # Generate a response from a single prompt string.
      # Convenience method that wraps the prompt in a HumanMessage.
      #
      # @param prompt [String] The prompt text
      # @param stop [Array<String>] Optional stop sequences
      # @return [Message] The AI's response message
      def call_prompt(prompt, stop: nil)
        messages = [Messages::HumanMessage.new(content: prompt)]
        call(messages, stop: stop)
      end

      # Stream a chat response.
      # Yields message chunks as they are generated.
      #
      # @param messages [Array<Message>] Array of message objects
      # @param stop [Array<String>] Optional stop sequences
      # @yield [Message] Chunks of the response message
      def stream(messages, stop: nil, &block)
        _stream(messages, stop: stop, &block)
      end

      protected

      # Generate a chat response. Must be implemented by subclasses.
      #
      # @param messages [Array<Message>] Array of message objects
      # @param stop [Array<String>] Optional stop sequences
      # @return [Message] The AI's response message
      def _generate(messages, stop: nil)
        raise NotImplementedError, "Subclasses must implement the '_generate' method"
      end

      # Stream a chat response. Should be implemented by subclasses that support streaming.
      #
      # @param messages [Array<Message>] Array of message objects
      # @param stop [Array<String>] Optional stop sequences
      # @yield [Message] Chunks of the response message
      def _stream(messages, stop: nil)
        raise NotImplementedError, "Subclasses must implement the '_stream' method"
      end
    end
  end
end
