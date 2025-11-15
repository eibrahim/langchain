# frozen_string_literal: true

require_relative "lib/langchain_rb/version"

Gem::Specification.new do |spec|
  spec.name = "langchain_rb"
  spec.version = LangchainRb::VERSION
  spec.authors = ["LangChain Contributors"]
  spec.email = [""]

  spec.summary = "Ruby implementation of LangChain framework for building LLM applications"
  spec.description = "LangChain Ruby is a framework for developing applications powered by language models. " \
                     "It provides abstractions for language models, prompts, chains, agents, and more."
  spec.homepage = "https://github.com/langchain-ai/langchain"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/langchain-ai/langchain"
  spec.metadata["changelog_uri"] = "https://github.com/langchain-ai/langchain/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir.glob("{lib,exe}/**/*") + %w[README.md LICENSE]
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Runtime dependencies
  spec.add_dependency "faraday", "~> 2.0"
  spec.add_dependency "faraday-retry", "~> 2.0"

  # Development dependencies
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "webmock", "~> 3.0"
  spec.add_development_dependency "vcr", "~> 6.0"
  spec.add_development_dependency "rubocop", "~> 1.0"
  spec.add_development_dependency "rake", "~> 13.0"
end
