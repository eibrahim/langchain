# frozen_string_literal: true

module LangchainRb
  module Messages
    # Base class for all message types in LangChain.
    # Messages represent individual units in a conversation.
    class Base
      attr_reader :content, :additional_kwargs

      def initialize(content:, additional_kwargs: {})
        @content = content
        @additional_kwargs = additional_kwargs
      end

      # Get the type of the message.
      #
      # @return [Symbol] The message type
      def type
        raise NotImplementedError, "Subclasses must implement the 'type' method"
      end

      # Convert the message to a hash representation.
      #
      # @return [Hash] Hash representation of the message
      def to_hash
        {
          type: type,
          content: content,
          additional_kwargs: additional_kwargs
        }
      end

      # Convert the message to a string representation.
      #
      # @return [String] String representation of the message
      def to_s
        "#{type}: #{content}"
      end
    end
  end
end
