# frozen_string_literal: true

require_relative "base"

module LangchainRb
  module Messages
    # Represents a message from the AI assistant in a conversation.
    class AIMessage < Base
      def type
        :ai
      end
    end
  end
end
