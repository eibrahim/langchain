# frozen_string_literal: true

module LangchainRb
  module Prompts
    # Base class for all prompt templates.
    # Defines the interface for creating and formatting prompts.
    class Base
      attr_reader :input_variables

      def initialize(input_variables:)
        @input_variables = input_variables
      end

      # Format the prompt with the given input values.
      #
      # @param kwargs [Hash] Input values for the template variables
      # @return [String] The formatted prompt
      def format(**kwargs)
        validate_input_variables(kwargs)
        _format(**kwargs)
      end

      # Format the prompt and return a PromptValue object.
      #
      # @param kwargs [Hash] Input values for the template variables
      # @return [Object] A PromptValue object
      def format_prompt(**kwargs)
        format(**kwargs)
      end

      protected

      # Internal method to format the prompt. Must be implemented by subclasses.
      #
      # @param kwargs [Hash] Input values for the template variables
      # @return [String] The formatted prompt
      def _format(**kwargs)
        raise NotImplementedError, "Subclasses must implement the '_format' method"
      end

      # Validate that all required input variables are provided.
      #
      # @param kwargs [Hash] Input values to validate
      # @raise [PromptError] If required variables are missing
      def validate_input_variables(kwargs)
        missing_vars = input_variables - kwargs.keys.map(&:to_sym)
        return if missing_vars.empty?

        raise PromptError, "Missing required input variables: #{missing_vars.join(', ')}"
      end
    end
  end
end
