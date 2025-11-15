# frozen_string_literal: true

RSpec.describe LangchainRb::Messages::HumanMessage do
  let(:message) { described_class.new(content: "Hello, world!") }

  describe "#type" do
    it "returns :human" do
      expect(message.type).to eq(:human)
    end
  end

  describe "#to_s" do
    it "returns formatted string" do
      expect(message.to_s).to eq("human: Hello, world!")
    end
  end

  describe "#to_hash" do
    it "returns hash representation" do
      hash = message.to_hash
      expect(hash[:type]).to eq(:human)
      expect(hash[:content]).to eq("Hello, world!")
      expect(hash[:additional_kwargs]).to eq({})
    end
  end
end

RSpec.describe LangchainRb::Messages::AIMessage do
  let(:message) { described_class.new(content: "Hello, human!") }

  describe "#type" do
    it "returns :ai" do
      expect(message.type).to eq(:ai)
    end
  end

  describe "#to_s" do
    it "returns formatted string" do
      expect(message.to_s).to eq("ai: Hello, human!")
    end
  end
end

RSpec.describe LangchainRb::Messages::SystemMessage do
  let(:message) { described_class.new(content: "You are a helpful assistant.") }

  describe "#type" do
    it "returns :system" do
      expect(message.type).to eq(:system)
    end
  end

  describe "#to_s" do
    it "returns formatted string" do
      expect(message.to_s).to eq("system: You are a helpful assistant.")
    end
  end
end
