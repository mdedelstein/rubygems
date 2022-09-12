# frozen_string_literal: true

module Bundler
  class Resolver
    class SpecGroup
      attr_accessor :name, :version, :source
      attr_accessor :activated_platforms, :force_ruby_platform

      def initialize(specs, relevant_platforms)
        @exemplary_spec = specs[relevant_platforms.first].first
        @name = @exemplary_spec.name
        @version = @exemplary_spec.version
        @source = @exemplary_spec.source

        @activated_platforms = relevant_platforms
        @specs = specs
      end

      def to_specs
        activated_platforms.map do |p|
          specs = @specs[p]
          next unless specs.any?

          specs.map do |s|
            lazy_spec = LazySpecification.new(name, version, s.platform, source)
            lazy_spec.force_ruby_platform = force_ruby_platform
            lazy_spec.dependencies.replace s.dependencies
            lazy_spec
          end
        end.flatten.compact.uniq
      end

      def to_s
        activated_platforms_string = sorted_activated_platforms.join(", ")
        "#{name} (#{version}) (#{activated_platforms_string})"
      end

      def dependencies_for_activated_platforms
        @dependencies_for_activated_platforms ||= dependencies_for(activated_platforms)
      end

      def ==(other)
        return unless other.is_a?(SpecGroup)
        name == other.name &&
          version == other.version &&
          sorted_activated_platforms == other.sorted_activated_platforms &&
          source == other.source
      end

      def eql?(other)
        return unless other.is_a?(SpecGroup)
        name.eql?(other.name) &&
          version.eql?(other.version) &&
          sorted_activated_platforms.eql?(other.sorted_activated_platforms) &&
          source.eql?(other.source)
      end

      def hash
        name.hash ^ version.hash ^ sorted_activated_platforms.hash ^ source.hash
      end

      protected

      def sorted_activated_platforms
        activated_platforms.sort_by(&:to_s)
      end

      private

      def dependencies_for(platforms)
        platforms.map do |platform|
          __dependencies(platform) + metadata_dependencies(platform)
        end.flatten
      end

      def __dependencies(platform)
        dependencies = []
        @specs[platform].first.dependencies.each do |dep|
          next if dep.type == :development
          dependencies << Dependency.new(dep.name, dep.requirement)
        end
        dependencies
      end

      def metadata_dependencies(platform)
        spec = @specs[platform].first
        return [] if spec.is_a?(LazySpecification)

        [
          metadata_dependency("Ruby", spec.required_ruby_version),
          metadata_dependency("RubyGems", spec.required_rubygems_version),
        ].compact
      end

      def metadata_dependency(name, requirement)
        return if requirement.nil? || requirement.none?

        Dependency.new("#{name}\0", requirement)
      end
    end
  end
end
