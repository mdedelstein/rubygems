# frozen_string_literal: true

module Bundler
  class CLI::Lock
    attr_reader :options

    def initialize(options)
      @options = options
    end

    def run
      unless Bundler.default_gemfile
        Bundler.ui.error "Unable to find a Gemfile to lock"
        exit 1
      end

      print = options[:print]
      ui = Bundler.ui
      Bundler.ui = UI::Silent.new if print

      Bundler::Fetcher.disable_endpoint = options["full-index"]

      update = options[:update]
      if update.is_a?(Array) # unlocking specific gems
        Bundler::CLI::Common.ensure_all_gems_in_lockfile!(update)
        update = { :gems => update, :lock_shared_dependencies => options[:conservative] }
      end
      definition_old = Bundler.definition
      definition = Bundler.definition(update)

      Bundler::CLI::Common.configure_gem_version_promoter(Bundler.definition, options) if options[:update]

      options["remove-platform"].each do |platform|
        definition.remove_platform(platform)
      end

      options["add-platform"].each do |platform_string|
        platform = Gem::Platform.new(platform_string)
        if platform.to_s == "unknown"
          Bundler.ui.warn "The platform `#{platform_string}` is unknown to RubyGems " \
            "and adding it will likely lead to resolution errors"
        end
        definition.add_platform(platform)
      end

      if definition.platforms.empty?
        raise InvalidOption, "Removing all platforms from the bundle is not allowed"
      end

      definition.resolve_remotely! unless options[:local]

      if options[:regenerate]
        # re-read the Gemfile definitions
        definition = Bundler.definition(true)
        definition.gem_version_promoter.level = :patch
        definition.resolve_remotely!

        # resolve to a spec set
        spec_set = definition.resolve
        # update the version in the new spec_set to match the old versions
        definition_old.specs.each do |spec|
          gem_spec = spec_set[spec.name].first
          if gem_spec
            gem_spec.instance_variable_set(:@version, spec.version)
            gem_spec.instance_variable_set(:@dependencies, spec.dependencies)
          end
        end
      end

      if print
        puts definition.to_lock
      else
        file = options[:lockfile]
        file = file ? File.expand_path(file) : Bundler.default_lockfile
        puts "Writing lockfile to #{file}"
        definition.lock(file)
      end

      Bundler.ui = ui
    end
  end
end
