# frozen_string_literal: true

require 'faraday'
require 'json'

module LangchainRb
  module Providers
    module AzureOpenAI
      # Azure OpenAI LLM implementation for text completions.
      # Supports Azure OpenAI Service API for completions.
      class LLM < LanguageModels::LLM
        attr_reader :api_key, :endpoint, :deployment_name, :api_version

        # Initialize Azure OpenAI LLM model.
        #
        # @param api_key [String] Azure OpenAI API key
        # @param endpoint [String] Azure OpenAI endpoint (e.g., "https://your-resource.openai.azure.com")
        # @param deployment_name [String] Name of your deployment in Azure
        # @param api_version [String] API version (default: "2024-02-01")
        # @param temperature [Float] Sampling temperature (0.0 to 2.0)
        # @param max_tokens [Integer] Maximum tokens to generate
        # @param streaming [Boolean] Whether to support streaming
        # @param callbacks [Array] Optional callbacks
        def initialize(
          api_key:,
          endpoint:,
          deployment_name:,
          api_version: '2024-02-01',
          temperature: 0.7,
          max_tokens: nil,
          streaming: false,
          callbacks: nil
        )
          super(
            model_name: deployment_name,
            temperature: temperature,
            max_tokens: max_tokens,
            streaming: streaming,
            callbacks: callbacks
          )
          @api_key = api_key
          @endpoint = endpoint.chomp('/')
          @deployment_name = deployment_name
          @api_version = api_version
        end

        protected

        # Generate a completion from Azure OpenAI.
        #
        # @param prompt [String] The prompt to complete
        # @param stop [Array<String>] Optional stop sequences
        # @return [String] The completion text
        def _generate(prompt, stop: nil)
          response = make_request(prompt, stop: stop, stream: false)
          text = response.dig('choices', 0, 'text')

          raise LLMError, 'No text in response' unless text

          text
        end

        # Stream a completion from Azure OpenAI.
        #
        # @param prompt [String] The prompt to complete
        # @param stop [Array<String>] Optional stop sequences
        # @yield [String] Chunks of generated text
        def _stream(prompt, stop: nil)
          # Streaming implementation would go here
          raise NotImplementedError, 'Streaming not yet implemented for Azure OpenAI'
        end

        private

        # Make HTTP request to Azure OpenAI API.
        #
        # @param prompt [String] The prompt to complete
        # @param stop [Array<String>] Optional stop sequences
        # @param stream [Boolean] Whether to stream the response
        # @return [Hash] Parsed JSON response
        def make_request(prompt, stop: nil, stream: false)
          url = build_url
          headers = build_headers
          body = build_request_body(prompt, stop: stop, stream: stream)

          conn = Faraday.new(url: url) do |f|
            f.request :json
            f.response :json
            f.adapter Faraday.default_adapter
          end

          response = conn.post do |req|
            req.headers = headers
            req.body = body
          end

          handle_response(response)
        end

        # Build the complete API URL.
        #
        # @return [String] Complete API URL
        def build_url
          "#{endpoint}/openai/deployments/#{deployment_name}/completions?api-version=#{api_version}"
        end

        # Build request headers.
        #
        # @return [Hash] Request headers
        def build_headers
          {
            'Content-Type' => 'application/json',
            'api-key' => api_key
          }
        end

        # Build request body for the API call.
        #
        # @param prompt [String] The prompt to complete
        # @param stop [Array<String>] Optional stop sequences
        # @param stream [Boolean] Whether to stream the response
        # @return [Hash] Request body
        def build_request_body(prompt, stop: nil, stream: false)
          body = {
            prompt: prompt,
            temperature: temperature,
            stream: stream
          }

          body[:max_tokens] = max_tokens if max_tokens
          body[:stop] = stop if stop && !stop.empty?

          body
        end

        # Handle the API response.
        #
        # @param response [Faraday::Response] HTTP response
        # @return [Hash] Parsed response body
        def handle_response(response)
          unless response.success?
            error_message = response.body.is_a?(Hash) ? response.body['error']['message'] : response.body
            raise LLMError, "Azure OpenAI API error (#{response.status}): #{error_message}"
          end

          response.body
        end
      end
    end
  end
end
