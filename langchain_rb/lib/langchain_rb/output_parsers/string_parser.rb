# frozen_string_literal: true

require_relative "base"

module LangchainRb
  module OutputParsers
    # Simple string output parser that returns the text as-is.
    # This is the default parser when no parsing is needed.
    class StringParser < Base
      # Parse the output (returns it as-is).
      #
      # @param text [String] The text output from the LLM
      # @return [String] The same text, with whitespace trimmed
      def parse(text)
        text.to_s.strip
      end

      # Get the type of the output parser.
      #
      # @return [Symbol] The parser type (:string)
      def type
        :string
      end
    end
  end
end
