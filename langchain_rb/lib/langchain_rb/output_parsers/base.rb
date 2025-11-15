# frozen_string_literal: true

module LangchainRb
  module OutputParsers
    # Base class for output parsers.
    # Output parsers transform LLM outputs into structured data.
    class Base
      # Parse the output from an LLM call.
      #
      # @param text [String] The text output from the LLM
      # @return [Object] The parsed output
      def parse(text)
        raise NotImplementedError, "Subclasses must implement the 'parse' method"
      end

      # Get instructions for the LLM on how to format its output.
      # This can be included in the prompt.
      #
      # @return [String] Instructions for the LLM
      def get_format_instructions
        ""
      end

      # Get the type of the output parser.
      #
      # @return [Symbol] The parser type
      def type
        raise NotImplementedError, "Subclasses must implement the 'type' method"
      end
    end
  end
end
