# frozen_string_literal: true

require_relative 'base'

module LangchainRb
  module Chains
    # Chain for calling a language model with a prompt template.
    # Combines a prompt template and a language model into a single chain.
    class LLMChain < Base
      attr_reader :llm, :prompt

      # Create a new LLM chain.
      #
      # @param llm [LanguageModels::Base] The language model to use
      # @param prompt [Prompts::Base] The prompt template to use
      # @param memory [Memory::Base] Optional memory for the chain
      # @param callbacks [Array] Optional callbacks
      # @param verbose [Boolean] Whether to enable verbose logging
      def initialize(llm:, prompt:, memory: nil, callbacks: nil, verbose: false)
        super(memory: memory, callbacks: callbacks, verbose: verbose)
        @llm = llm
        @prompt = prompt
      end

      # Get the input keys for this chain.
      #
      # @return [Array<Symbol>] Array of input variable names
      def input_keys
        prompt.input_variables
      end

      # Get the output keys for this chain.
      #
      # @return [Array<Symbol>] Array of output variable names
      def output_keys
        [:text]
      end

      # Predict the output for a given input.
      # Convenience method that returns just the text output.
      #
      # @param kwargs [Hash] Input values for the prompt template
      # @return [String] The generated text
      def predict(**kwargs)
        result = call(kwargs)
        result[:text]
      end

      protected

      # Execute the LLM chain.
      #
      # @param inputs [Hash] Input values for the chain
      # @return [Hash] Output containing the generated text
      def _call(inputs)
        log("Formatting prompt with inputs: #{inputs.inspect}")

        # Format the prompt
        formatted_prompt = prompt.format(**inputs)
        log("Formatted prompt: #{formatted_prompt}")

        # Call the LLM
        log('Calling LLM...')
        response = llm.call(formatted_prompt)
        log("LLM response: #{response}")

        { text: response }
      end
    end
  end
end
