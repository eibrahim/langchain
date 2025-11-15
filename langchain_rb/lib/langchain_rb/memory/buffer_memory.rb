# frozen_string_literal: true

require_relative "base"

module LangchainRb
  module Memory
    # Simple buffer memory that stores conversation history.
    # Keeps a running list of messages in a buffer.
    class BufferMemory < Base
      attr_reader :memory_key, :input_key, :output_key, :return_messages

      # Create a new buffer memory.
      #
      # @param memory_key [Symbol] The key to use for memory in the chain
      # @param input_key [Symbol] The key for input in the chain
      # @param output_key [Symbol] The key for output in the chain
      # @param return_messages [Boolean] Whether to return messages or string
      def initialize(memory_key: :history, input_key: :input, output_key: :text, return_messages: false)
        @memory_key = memory_key
        @input_key = input_key
        @output_key = output_key
        @return_messages = return_messages
        @chat_memory = []
      end

      # Get the memory variables.
      #
      # @return [Array<Symbol>] Array containing the memory key
      def memory_variables
        [memory_key]
      end

      # Load memory variables for the current context.
      #
      # @param inputs [Hash] Current input values (unused)
      # @return [Hash] Hash with memory key and conversation history
      def load_memory_variables(inputs = {})
        if return_messages
          { memory_key => @chat_memory.dup }
        else
          { memory_key => buffer_as_str }
        end
      end

      # Save context from this chain run to memory.
      #
      # @param inputs [Hash] Input values from the chain
      # @param outputs [Hash] Output values from the chain
      def save_context(inputs, outputs)
        input_str = inputs[input_key]
        output_str = outputs[output_key]
        
        @chat_memory << Messages::HumanMessage.new(content: input_str) if input_str
        @chat_memory << Messages::AIMessage.new(content: output_str) if output_str
      end

      # Clear the memory buffer.
      def clear
        @chat_memory.clear
      end

      # Get the buffer as a string.
      #
      # @return [String] The conversation history as a formatted string
      def buffer_as_str
        @chat_memory.map(&:to_s).join("\n")
      end

      # Get the buffer as an array of messages.
      #
      # @return [Array<Message>] Array of message objects
      def buffer_as_messages
        @chat_memory.dup
      end
    end
  end
end
