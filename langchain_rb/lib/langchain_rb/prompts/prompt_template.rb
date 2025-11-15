# frozen_string_literal: true

require_relative "base"

module LangchainRb
  module Prompts
    # Template for creating prompts with variable substitution.
    # Uses simple string interpolation with {variable} syntax.
    class PromptTemplate < Base
      attr_reader :template

      # Create a new prompt template.
      #
      # @param template [String] The template string with {variable} placeholders
      # @param input_variables [Array<Symbol>] List of variable names
      def initialize(template:, input_variables:)
        super(input_variables: input_variables)
        @template = template
      end

      # Create a prompt template from a template string.
      # Automatically detects input variables from {variable} syntax.
      #
      # @param template [String] The template string
      # @return [PromptTemplate] A new prompt template
      def self.from_template(template)
        input_variables = template.scan(/\{(\w+)\}/).flatten.map(&:to_sym).uniq
        new(template: template, input_variables: input_variables)
      end

      protected

      # Format the template with the given input values.
      #
      # @param kwargs [Hash] Input values for the template variables
      # @return [String] The formatted prompt
      def _format(**kwargs)
        formatted = template.dup
        kwargs.each do |key, value|
          formatted.gsub!("{#{key}}", value.to_s)
        end
        formatted
      end
    end
  end
end
