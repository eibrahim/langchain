# frozen_string_literal: true

require 'faraday'
require 'json'

module LangchainRb
  module Providers
    module AzureOpenAI
      # Azure OpenAI Chat implementation for conversational models.
      # Supports Azure OpenAI Service API for chat completions.
      class Chat < LanguageModels::ChatModel
        attr_reader :api_key, :endpoint, :deployment_name, :api_version

        # Initialize Azure OpenAI Chat model.
        #
        # @param api_key [String] Azure OpenAI API key
        # @param endpoint [String] Azure OpenAI endpoint (e.g., "https://your-resource.openai.azure.com")
        # @param deployment_name [String] Name of your deployment in Azure
        # @param api_version [String] API version (default: "2024-02-01")
        # @param temperature [Float] Sampling temperature (0.0 to 2.0)
        # @param max_tokens [Integer] Maximum tokens to generate
        # @param callbacks [Array] Optional callbacks
        def initialize(
          api_key:,
          endpoint:,
          deployment_name:,
          api_version: '2024-02-01',
          temperature: 0.7,
          max_tokens: nil,
          callbacks: nil
        )
          super(
            model_name: deployment_name,
            temperature: temperature,
            max_tokens: max_tokens,
            callbacks: callbacks
          )
          @api_key = api_key
          @endpoint = endpoint.chomp('/')
          @deployment_name = deployment_name
          @api_version = api_version
        end

        protected

        # Generate a chat response from Azure OpenAI.
        #
        # @param messages [Array<Message>] Array of message objects
        # @param stop [Array<String>] Optional stop sequences
        # @return [Message] The AI's response message
        def _generate(messages, stop: nil)
          response = make_request(messages, stop: stop, stream: false)
          content = response.dig('choices', 0, 'message', 'content')

          raise LLMError, 'No content in response' unless content

          Messages::AIMessage.new(content: content)
        end

        # Stream a chat response from Azure OpenAI.
        #
        # @param messages [Array<Message>] Array of message objects
        # @param stop [Array<String>] Optional stop sequences
        # @yield [Message] Chunks of the response message
        def _stream(messages, stop: nil)
          # Streaming implementation would go here
          raise NotImplementedError, 'Streaming not yet implemented for Azure OpenAI'
        end

        private

        # Make HTTP request to Azure OpenAI API.
        #
        # @param messages [Array<Message>] Array of message objects
        # @param stop [Array<String>] Optional stop sequences
        # @param stream [Boolean] Whether to stream the response
        # @return [Hash] Parsed JSON response
        def make_request(messages, stop: nil, stream: false)
          url = build_url
          headers = build_headers
          body = build_request_body(messages, stop: stop, stream: stream)

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
          "#{endpoint}/openai/deployments/#{deployment_name}/chat/completions?api-version=#{api_version}"
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
        # @param messages [Array<Message>] Array of message objects
        # @param stop [Array<String>] Optional stop sequences
        # @param stream [Boolean] Whether to stream the response
        # @return [Hash] Request body
        def build_request_body(messages, stop: nil, stream: false)
          body = {
            messages: format_messages(messages),
            temperature: temperature,
            stream: stream
          }

          body[:max_tokens] = max_tokens if max_tokens
          body[:stop] = stop if stop && !stop.empty?

          body
        end

        # Format messages for the API.
        #
        # @param messages [Array<Message>] Array of message objects
        # @return [Array<Hash>] Formatted messages
        def format_messages(messages)
          messages.map do |msg|
            {
              role: message_role(msg),
              content: msg.content
            }
          end
        end

        # Get the role string for a message.
        #
        # @param message [Message] Message object
        # @return [String] Role string
        def message_role(message)
          case message.type
          when :human
            'user'
          when :ai
            'assistant'
          when :system
            'system'
          else
            raise ArgumentError, "Unknown message type: #{message.type}"
          end
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
