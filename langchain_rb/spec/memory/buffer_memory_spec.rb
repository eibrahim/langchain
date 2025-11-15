# frozen_string_literal: true

RSpec.describe LangchainRb::Memory::BufferMemory do
  let(:memory) { described_class.new }

  describe "#initialize" do
    it "sets default values" do
      expect(memory.memory_key).to eq(:history)
      expect(memory.input_key).to eq(:input)
      expect(memory.output_key).to eq(:text)
      expect(memory.return_messages).to be false
    end

    it "allows custom keys" do
      custom_memory = described_class.new(
        memory_key: :chat_history,
        input_key: :question,
        output_key: :answer
      )

      expect(custom_memory.memory_key).to eq(:chat_history)
      expect(custom_memory.input_key).to eq(:question)
      expect(custom_memory.output_key).to eq(:answer)
    end
  end

  describe "#save_context" do
    it "saves input and output to memory" do
      memory.save_context(
        { input: "Hello" },
        { text: "Hi there!" }
      )

      buffer = memory.buffer_as_messages
      expect(buffer.length).to eq(2)
      expect(buffer[0]).to be_a(LangchainRb::Messages::HumanMessage)
      expect(buffer[0].content).to eq("Hello")
      expect(buffer[1]).to be_a(LangchainRb::Messages::AIMessage)
      expect(buffer[1].content).to eq("Hi there!")
    end
  end

  describe "#load_memory_variables" do
    before do
      memory.save_context(
        { input: "Hello" },
        { text: "Hi there!" }
      )
    end

    context "when return_messages is false" do
      it "returns memory as a string" do
        vars = memory.load_memory_variables
        expect(vars[:history]).to be_a(String)
        expect(vars[:history]).to include("human: Hello")
        expect(vars[:history]).to include("ai: Hi there!")
      end
    end

    context "when return_messages is true" do
      let(:memory) { described_class.new(return_messages: true) }

      it "returns memory as message objects" do
        vars = memory.load_memory_variables
        expect(vars[:history]).to be_an(Array)
        expect(vars[:history].length).to eq(2)
        expect(vars[:history][0]).to be_a(LangchainRb::Messages::HumanMessage)
        expect(vars[:history][1]).to be_a(LangchainRb::Messages::AIMessage)
      end
    end
  end

  describe "#clear" do
    it "clears the memory buffer" do
      memory.save_context({ input: "Hello" }, { text: "Hi!" })
      expect(memory.buffer_as_messages).not_to be_empty

      memory.clear
      expect(memory.buffer_as_messages).to be_empty
    end
  end

  describe "#buffer_as_str" do
    it "returns formatted string of conversation" do
      memory.save_context({ input: "Hello" }, { text: "Hi!" })
      memory.save_context({ input: "How are you?" }, { text: "I'm good!" })

      buffer_str = memory.buffer_as_str
      expect(buffer_str).to include("human: Hello")
      expect(buffer_str).to include("ai: Hi!")
      expect(buffer_str).to include("human: How are you?")
      expect(buffer_str).to include("ai: I'm good!")
    end
  end
end
