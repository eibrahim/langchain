# frozen_string_literal: true

require_relative "base"

module LangchainRb
  module Messages
    # Represents a message from a human/user in a conversation.
    class HumanMessage < Base
      def type
        :human
      end
    end
  end
end
