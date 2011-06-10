require 'rubygems/command'
require 'rubygems/install_update_options'
require 'rubygems/dependency_installer'
require 'rubygems/local_remote_options'
require 'rubygems/validator'
require 'rubygems/version_option'
require 'rubygems/install_message' # must come before rdoc for messaging
require 'rubygems/rdoc'

##
# Gem installer command line tool
#
# See `gem help install`

class Gem::Commands::InstallCommand < Gem::Command

  attr_reader :installed_specs # :nodoc:

  include Gem::VersionOption
  include Gem::LocalRemoteOptions
  include Gem::InstallUpdateOptions

  def initialize
    defaults = Gem::DependencyInstaller::DEFAULT_OPTIONS.merge({
      :format_executable => false,
      :version           => Gem::Requirement.default,
    })

    super 'install', 'Install a gem into the local repository', defaults

    add_install_update_options
    add_local_remote_options
    add_platform_option
    add_version_option
    add_prerelease_option "to be installed. (Only for listed gems)"

    @installed_specs = nil
  end

  def arguments # :nodoc:
    "GEMNAME       name of gem to install"
  end

  def defaults_str # :nodoc:
    "--both --version '#{Gem::Requirement.default}' --rdoc --ri --no-force\n" \
    "--install-dir #{Gem.dir}"
  end

  def description # :nodoc:
    <<-EOF
The install command installs local or remote gem into a gem repository.

For gems with executables ruby installs a wrapper file into the executable
directory by default.  This can be overridden with the --no-wrappers option.
The wrapper allows you to choose among alternate gem versions using _version_.

For example `rake _0.7.3_ --version` will run rake version 0.7.3 if a newer
version is also installed.

If an extension fails to compile during gem installation the gem
specification is not written out, but the gem remains unpacked in the
repository.  You may need to specify the path to the library's headers and
libraries to continue.  You can do this by adding a -- between RubyGems'
options and the extension's build options:

  $ gem install some_extension_gem
  [build fails]
  Gem files will remain installed in \\
  /path/to/gems/some_extension_gem-1.0 for inspection.
  Results logged to /path/to/gems/some_extension_gem-1.0/gem_make.out
  $ gem install some_extension_gem -- --with-extension-lib=/path/to/lib
  [build succeeds]
  $ gem list some_extension_gem

  *** LOCAL GEMS ***

  some_extension_gem (1.0)
  $

If you correct the compilation errors by editing the gem files you will need
to write the specification by hand.  For example:

  $ gem install some_extension_gem
  [build fails]
  Gem files will remain installed in \\
  /path/to/gems/some_extension_gem-1.0 for inspection.
  Results logged to /path/to/gems/some_extension_gem-1.0/gem_make.out
  $ [cd /path/to/gems/some_extension_gem-1.0]
  $ [edit files or what-have-you and run make]
  $ gem spec ../../cache/some_extension_gem-1.0.gem --ruby > \\
             ../../specifications/some_extension_gem-1.0.gemspec
  $ gem list some_extension_gem

  *** LOCAL GEMS ***

  some_extension_gem (1.0)
  $

    EOF
  end

  def usage # :nodoc:
    "#{program_name} GEMNAME [GEMNAME ...] [options] -- --build-flags"
  end

  def execute
    if options[:include_dependencies] then
      alert "`gem install -y` is now default and will be removed"
      alert "use --ignore-dependencies to install only the gems you list"
    end

    @installed_specs = []

    ENV.delete 'GEM_PATH' if options[:install_dir].nil? and RUBY_VERSION > '1.9'

    if options[:install_dir] and options[:user_install]
      alert_error "Use --install-dir or --user-install but not both"
      terminate_interaction 1
    end

    exit_code = 0

    get_all_gem_names.each do |gem_name|
      begin
        next if options[:conservative] and
          not Gem::Dependency.new(gem_name, options[:version]).matching_specs.empty?

        inst = Gem::DependencyInstaller.new options
        inst.install gem_name, options[:version]

        @installed_specs.push(*inst.installed_gems)
      rescue Gem::InstallError => e
        alert_error "Error installing #{gem_name}:\n\t#{e.message}"
        exit_code |= 1
      rescue Gem::GemNotFoundException => e
        show_lookup_failure e.name, e.version, e.errors, options[:domain]

        exit_code |= 2
      end
    end

    unless @installed_specs.empty? then
      gems = @installed_specs.length == 1 ? 'gem' : 'gems'
      say "#{@installed_specs.length} #{gems} installed"
    end

    raise Gem::SystemExitException, exit_code
  end

end

