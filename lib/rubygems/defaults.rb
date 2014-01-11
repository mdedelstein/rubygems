module Gem
  DEFAULT_HOST = "https://rubygems.org"

  @post_install_hooks   ||= []
  @done_installing_hooks  ||= []
  @post_uninstall_hooks ||= []
  @pre_uninstall_hooks  ||= []
  @pre_install_hooks    ||= []

  ##
  # An Array of the default sources that come with RubyGems

  def self.default_sources
    %w[https://rubygems.org/]
  end

  ##
  # Default spec directory path to be used if an alternate value is not
  # specified in the environment

  def self.default_spec_cache_dir
    File.join Gem.user_home, '.gem', 'specs'
  end

  ##
  # Default home directory path to be used if an alternate value is not
  # specified in the environment

  def self.default_dir
    path = if defined? RUBY_FRAMEWORK_VERSION
             [
               File.dirname(RbConfig::CONFIG['sitedir']),
               'Gems',
               RbConfig::CONFIG['ruby_version']
             ]
           elsif RbConfig::CONFIG['rubylibprefix']
             [
              RbConfig::CONFIG['rubylibprefix'],
              'gems',
              RbConfig::CONFIG['ruby_version']
             ]
           else
             [
               RbConfig::CONFIG['libdir'],
               ruby_engine,
               'gems',
               RbConfig::CONFIG['ruby_version']
             ]
           end

    @default_dir ||= File.join(*path)
  end

  ##
  # Returns binary extensions dir for specified RubyGems base dir or nil
  # if such directory cannot be determined.
  #
  # By default, the binary extensions are located side by side with their
  # Ruby counterparts, therefore nil is returned

  def self.default_ext_dir_for base_dir
    nil
  end

  ##
  # Paths where RubyGems' .rb files and bin files are installed

  def self.default_rubygems_dirs
    nil # default to standard layout
  end

  ##
  # Path for gems in the user's home directory

  def self.user_dir
    parts = [Gem.user_home, '.gem', ruby_engine]
    parts << RbConfig::CONFIG['ruby_version'] unless RbConfig::CONFIG['ruby_version'].empty?
    File.join parts
  end

  ##
  # How String Gem paths should be split.  Overridable for esoteric platforms.

  def self.path_separator
    File::PATH_SEPARATOR
  end

  ##
  # Default gem load path

  def self.default_path
    if Gem.user_home && File.exist?(Gem.user_home)
      [user_dir, default_dir]
    else
      [default_dir]
    end
  end

  ##
  # Deduce Ruby's --program-prefix and --program-suffix from its install name

  def self.default_exec_format
    exec_format = RbConfig::CONFIG['ruby_install_name'].sub('ruby', '%s') rescue '%s'

    unless exec_format =~ /%s/
      raise Gem::Exception,
        "[BUG] invalid exec_format #{exec_format.inspect}, no %s"
    end

    exec_format
  end

  ##
  # The default directory for binaries

  def self.default_bindir
    if defined? RUBY_FRAMEWORK_VERSION # mac framework support
      '/usr/bin'
    else # generic install
      RbConfig::CONFIG['bindir']
    end
  end

  ##
  # A wrapper around RUBY_ENGINE const that may not be defined

  def self.ruby_engine
    if defined? RUBY_ENGINE
      RUBY_ENGINE
    else
      'ruby'
    end
  end

  ##
  # The default signing key path

  def self.default_key_path
    File.join Gem.user_home, ".gem", "gem-private_key.pem"
  end

  ##
  # The default signing certificate chain path

  def self.default_cert_path
    File.join Gem.user_home, ".gem", "gem-public_cert.pem"
  end

  ##
  # Whether to expect full paths in default gems - true for non-MRI
  # ruby implementations
  def self.default_gems_use_full_paths?
    ruby_engine != 'ruby'
  end

  ##
  # Install extensions into lib as well as into the extension directory.

  def self.install_extension_in_lib # :nodoc:
    true
  end

end
