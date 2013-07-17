require 'rubygems/command'
require 'rubygems/version_option'
require 'rubygems/uninstaller'
require 'fileutils'

##
# Gem uninstaller command line tool
#
# See `gem help uninstall`

class Gem::Commands::UninstallCommand < Gem::Command

  include Gem::VersionOption

  def initialize
    super 'uninstall', 'Uninstall gems from the local repository',
          :version => Gem::Requirement.default, :user_install => true,
          :check_dev => false

    add_option('-a', '--[no-]all',
      'Uninstall all matching versions'
      ) do |value, options|
      options[:all] = value
    end

    add_option('-I', '--[no-]ignore-dependencies',
               'Ignore dependency requirements while',
               'uninstalling') do |value, options|
      options[:ignore] = value
    end

    add_option('-D', '--[no-]-check-development',
               'Check development dependencies while uninstalling',
               '(default: false)') do |value, options|
      options[:check_dev] = value
    end

    add_option('-x', '--[no-]executables',
                 'Uninstall applicable executables without',
                 'confirmation') do |value, options|
      options[:executables] = value
    end

    add_option('-i', '--install-dir DIR',
               'Directory to uninstall gem from') do |value, options|
      options[:install_dir] = File.expand_path(value)
    end

    add_option('-n', '--bindir DIR',
               'Directory to remove binaries from') do |value, options|
      options[:bin_dir] = File.expand_path(value)
    end

    add_option('--[no-]user-install',
               'Uninstall from user\'s home directory',
               'in addition to GEM_HOME.') do |value, options|
      options[:user_install] = value
    end

    add_option('--[no-]format-executable',
               'Assume executable names match Ruby\'s prefix and suffix.') do |value, options|
      options[:format_executable] = value
    end

    add_option('--[no-]force',
               'Uninstall all versions of the named gems',
               'ignoring dependencies') do |value, options|
      options[:force] = value
    end

    add_option('--[no-]abort-on-dependent',
               'Prevent uninstalling gems that are',
               'depended on by other gems.') do |value, options|
      options[:abort_on_dependent] = value
    end

    add_version_option
    add_platform_option
  end

  def arguments # :nodoc:
    "GEMNAME       name of gem to uninstall"
  end

  def defaults_str # :nodoc:
    "--version '#{Gem::Requirement.default}' --no-force " +
    "--install-dir #{Gem.dir}\n" +
    "--user-install"
  end

  def usage # :nodoc:
    "#{program_name} GEMNAME [GEMNAME ...]"
  end

  def execute
    # REFACTOR: stolen from cleanup_command
    if options[:args].empty? && options[:all] then
      remove_executables = if options[:executables].nil? then
        ask_yes_no("Remove executables in addition to gems?",
                   true)
      else
        true
      end

      dirs_to_be_emptied = Dir[File.join(Gem.dir, '*')]
      dirs_to_be_emptied.delete_if { |dir| dir.end_with? 'build_info' }
      unless remove_executables
        dirs_to_be_emptied.delete_if { |dir| dir.end_with? 'bin' }
      end

      dirs_to_be_emptied.each do |dir|
        FileUtils.rm_rf Dir[File.join(dir, '*')]
      end
      alert("Successfully uninstalled all gems")
    else
      deplist = Gem::DependencyList.new

      get_all_gem_names.uniq.each do |name|
        Gem::Specification.find_all_by_name(name).each do |spec|
          deplist.add spec
        end
      end

      deps = deplist.strongly_connected_components.flatten.reverse

      deps.map(&:name).uniq.each do |gem_name|
        begin
          Gem::Uninstaller.new(gem_name, options).uninstall
        rescue Gem::GemNotInHomeException => e
          spec = e.spec
          alert("In order to remove #{spec.name}, please execute:\n" +
                "\tgem uninstall #{spec.name} --install-dir=#{spec.installation_path}")
        end
      end
    end
  end

end

