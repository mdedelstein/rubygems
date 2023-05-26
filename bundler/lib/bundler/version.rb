# frozen_string_literal: false

module Bundler
  VERSION = "2.5.0.dev".freeze
  EFFECTIVE_VERSION = (ENV["BUNDLER_EFFECTIVE_VERSION"] || VERSION).freeze

  def self.bundler_major_version
    @bundler_major_version ||= VERSION.split(".").first.to_i
  end

  def self.effective_major_version
    @effective_major_version ||= EFFECTIVE_VERSION.split(".").first.to_i
  end

  def self.gem_version
    @gem_version ||= Gem::Version.create(VERSION)
  end
end
