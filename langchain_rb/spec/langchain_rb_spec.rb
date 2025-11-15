# frozen_string_literal: true

RSpec.describe LangchainRb do
  it "has a version number" do
    expect(LangchainRb::VERSION).not_to be nil
  end

  describe ".configuration" do
    it "returns a configuration object" do
      expect(LangchainRb.configuration).to be_a(LangchainRb::Configuration)
    end

    it "allows setting verbose mode" do
      LangchainRb.configure do |config|
        config.verbose = true
      end
      expect(LangchainRb.configuration.verbose).to be true
    end

    after do
      LangchainRb.reset_configuration!
    end
  end
end
