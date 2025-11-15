# frozen_string_literal: true

require_relative "base"

module LangchainRb
  module Messages
    # Represents a system message that sets context for the conversation.
    class SystemMessage < Base
      def type
        :system
      end
    end
  end
end
