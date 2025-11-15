# frozen_string_literal: true

module LangchainRb
  module Chains
    # Base class for all chains in LangChain.
    # Chains are used to combine multiple components together.
    class Base
      attr_reader :memory, :callbacks, :verbose

      def initialize(memory: nil, callbacks: nil, verbose: false)
        @memory = memory
        @callbacks = callbacks || []
        @verbose = verbose
      end

      # Run the chain with the given inputs.
      #
      # @param inputs [Hash] Input values for the chain
      # @return [Hash] Output values from the chain
      def call(inputs)
        run_before_callbacks(inputs)
        
        begin
          # Load memory context if available
          inputs = load_memory_variables(inputs) if memory
          
          # Execute the chain
          outputs = _call(inputs)
          
          # Save to memory if available
          save_memory(inputs, outputs) if memory
          
          run_after_callbacks(outputs)
          outputs
        rescue StandardError => e
          run_error_callbacks(e)
          raise ChainError, "Chain execution failed: #{e.message}"
        end
      end

      # Alias for call method
      def run(inputs)
        call(inputs)
      end

      protected

      # Internal method to execute the chain. Must be implemented by subclasses.
      #
      # @param inputs [Hash] Input values for the chain
      # @return [Hash] Output values from the chain
      def _call(inputs)
        raise NotImplementedError, "Subclasses must implement the '_call' method"
      end

      # Load variables from memory.
      #
      # @param inputs [Hash] Current input values
      # @return [Hash] Input values merged with memory variables
      def load_memory_variables(inputs)
        memory_vars = memory.load_memory_variables(inputs)
        inputs.merge(memory_vars)
      end

      # Save inputs and outputs to memory.
      #
      # @param inputs [Hash] Input values
      # @param outputs [Hash] Output values
      def save_memory(inputs, outputs)
        memory.save_context(inputs, outputs)
      end

      # Execute callbacks before chain execution
      def run_before_callbacks(inputs)
        callbacks.each { |callback| callback.on_chain_start(inputs) if callback.respond_to?(:on_chain_start) }
      end

      # Execute callbacks after chain execution
      def run_after_callbacks(outputs)
        callbacks.each { |callback| callback.on_chain_end(outputs) if callback.respond_to?(:on_chain_end) }
      end

      # Execute callbacks on error
      def run_error_callbacks(error)
        callbacks.each { |callback| callback.on_chain_error(error) if callback.respond_to?(:on_chain_error) }
      end

      # Log a message if verbose mode is enabled
      def log(message)
        puts message if verbose
      end
    end
  end
end
