# frozen_string_literal: true

require_relative 'base'

module LangchainRb
  module Prompts
    # Template for creating chat prompts from a sequence of messages.
    class ChatPromptTemplate < Base
      attr_reader :messages

      # Create a new chat prompt template.
      #
      # @param messages [Array] Array of message templates
      # @param input_variables [Array<Symbol>] List of variable names
      def initialize(messages:, input_variables:)
        super(input_variables: input_variables)
        @messages = messages
      end

      # Create a chat prompt template from message tuples.
      # Each tuple is [role, content] where role is :system, :human, or :ai.
      #
      # @param messages [Array<Array>] Array of [role, content] tuples
      # @return [ChatPromptTemplate] A new chat prompt template
      def self.from_messages(messages)
        input_variables = []
        message_templates = messages.map do |role, content|
          vars = content.scan(/\{(\w+)\}/).flatten.map(&:to_sym)
          input_variables.concat(vars)
          { role: role, content: content }
        end

        new(messages: message_templates, input_variables: input_variables.uniq)
      end

      # Format the chat prompt and return an array of message objects.
      #
      # @param kwargs [Hash] Input values for the template variables
      # @return [Array<Message>] Array of formatted message objects
      def format_messages(**kwargs)
        validate_input_variables(kwargs)

        messages.map do |msg_template|
          content = msg_template[:content].dup
          kwargs.each do |key, value|
            content.gsub!("{#{key}}", value.to_s)
          end

          case msg_template[:role]
          when :system
            Messages::SystemMessage.new(content: content)
          when :human
            Messages::HumanMessage.new(content: content)
          when :ai
            Messages::AIMessage.new(content: content)
          else
            raise PromptError, "Unknown message role: #{msg_template[:role]}"
          end
        end
      end

      protected

      # Format the template with the given input values.
      # Returns a string representation for compatibility.
      #
      # @param kwargs [Hash] Input values for the template variables
      # @return [String] The formatted prompt as a string
      def _format(**kwargs)
        format_messages(**kwargs).map(&:to_s).join("\n")
      end
    end
  end
end
