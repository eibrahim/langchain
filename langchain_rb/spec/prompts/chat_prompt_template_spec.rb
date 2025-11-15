# frozen_string_literal: true

RSpec.describe LangchainRb::Prompts::ChatPromptTemplate do
  describe ".from_messages" do
    it "creates a template from message tuples" do
      template = described_class.from_messages([
        [:system, "You are a helpful assistant."],
        [:human, "Hello {name}!"],
        [:ai, "Hi there!"]
      ])

      expect(template.input_variables).to contain_exactly(:name)
      expect(template.messages.length).to eq(3)
    end
  end

  describe "#format_messages" do
    let(:template) do
      described_class.from_messages([
        [:system, "You are a {role} assistant."],
        [:human, "My name is {name}."],
        [:ai, "Nice to meet you, {name}!"]
      ])
    end

    it "formats messages with provided variables" do
      messages = template.format_messages(role: "helpful", name: "Alice")

      expect(messages.length).to eq(3)
      expect(messages[0]).to be_a(LangchainRb::Messages::SystemMessage)
      expect(messages[0].content).to eq("You are a helpful assistant.")
      expect(messages[1]).to be_a(LangchainRb::Messages::HumanMessage)
      expect(messages[1].content).to eq("My name is Alice.")
      expect(messages[2]).to be_a(LangchainRb::Messages::AIMessage)
      expect(messages[2].content).to eq("Nice to meet you, Alice!")
    end

    it "raises an error for unknown message roles" do
      bad_template = described_class.from_messages([
        [:unknown_role, "Test message"]
      ])

      expect { bad_template.format_messages }
        .to raise_error(LangchainRb::PromptError, /Unknown message role/)
    end
  end

  describe "#format" do
    let(:template) do
      described_class.from_messages([
        [:system, "You are a helpful assistant."],
        [:human, "Hello!"]
      ])
    end

    it "returns a string representation of messages" do
      result = template.format
      expect(result).to include("system: You are a helpful assistant.")
      expect(result).to include("human: Hello!")
    end
  end
end
