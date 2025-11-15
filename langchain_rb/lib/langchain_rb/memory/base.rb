# frozen_string_literal: true

module LangchainRb
  module Memory
    # Base class for all memory implementations.
    # Memory is used to persist state between chain calls.
    class Base
      # Get the memory variables.
      #
      # @return [Array<Symbol>] Array of memory variable names
      def memory_variables
        raise NotImplementedError, "Subclasses must implement the 'memory_variables' method"
      end

      # Load memory variables for the current context.
      #
      # @param inputs [Hash] Current input values
      # @return [Hash] Memory variables to merge with inputs
      def load_memory_variables(inputs)
        raise NotImplementedError, "Subclasses must implement the 'load_memory_variables' method"
      end

      # Save context from this chain run to memory.
      #
      # @param inputs [Hash] Input values from the chain
      # @param outputs [Hash] Output values from the chain
      def save_context(inputs, outputs)
        raise NotImplementedError, "Subclasses must implement the 'save_context' method"
      end

      # Clear the memory.
      def clear
        raise NotImplementedError, "Subclasses must implement the 'clear' method"
      end
    end
  end
end
