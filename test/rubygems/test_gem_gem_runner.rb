# frozen_string_literal: true
require 'rubygems/test_case'

class TestGemGemRunner < Gem::TestCase
  def setup
    super

    require 'rubygems/command'
    @orig_args = Gem::Command.build_args
    @orig_specific_extra_args = Gem::Command.specific_extra_args_hash.dup
    @orig_extra_args = Gem::Command.extra_args.dup

    require 'rubygems/gem_runner'
    @runner = Gem::GemRunner.new

    singleton_gem_class.class_eval do
      alias_method :orig_latest_rubygems_version, :latest_rubygems_version

      def latest_rubygems_version
        Gem.rubygems_version
      end
    end
  end

  def teardown
    super

    Gem::Command.build_args = @orig_args
    Gem::Command.specific_extra_args_hash = @orig_specific_extra_args
    Gem::Command.extra_args = @orig_extra_args
    singleton_gem_class.class_eval do
      remove_method :latest_rubygems_version
      alias_method :latest_rubygems_version, :orig_latest_rubygems_version
    end
  end

  def test_do_configuration
    Gem.clear_paths

    temp_conf = File.join @tempdir, '.gemrc'

    other_gem_path = File.join @tempdir, 'other_gem_path'
    other_gem_home = File.join @tempdir, 'other_gem_home'

    Gem.ensure_gem_subdirectories other_gem_path
    Gem.ensure_gem_subdirectories other_gem_home

    File.open temp_conf, 'w' do |fp|
      fp.puts "gem: --commands"
      fp.puts "gemhome: #{other_gem_home}"
      fp.puts "gempath:"
      fp.puts "  - #{other_gem_path}"
      fp.puts "rdoc: --all"
    end

    gr = Gem::GemRunner.new
    gr.send :do_configuration, %W[--config-file #{temp_conf}]

    assert_equal [other_gem_path, other_gem_home], Gem.path
    assert_equal %w[--commands], Gem::Command.extra_args
  end

  def test_extract_build_args
    args = %w[]
    assert_equal [], @runner.extract_build_args(args)
    assert_equal %w[], args

    args = %w[foo]
    assert_equal [], @runner.extract_build_args(args)
    assert_equal %w[foo], args

    args = %w[--foo]
    assert_equal [], @runner.extract_build_args(args)
    assert_equal %w[--foo], args

    args = %w[--foo --]
    assert_equal [], @runner.extract_build_args(args)
    assert_equal %w[--foo], args

    args = %w[--foo -- --bar]
    assert_equal %w[--bar], @runner.extract_build_args(args)
    assert_equal %w[--foo], args
  end

  def test_query_is_deprecated
    args = %w[query]

    use_ui @ui do
      assert_nil @runner.run(args)
    end

    assert_match(/WARNING:  query command is deprecated. It will be removed in Rubygems [0-9]+/, @ui.error)
  end

  def test_info_succeeds
    args = %w[info]

    use_ui @ui do
      assert_nil @runner.run(args)
    end

    assert_empty @ui.error
  end

  def test_list_succeeds
    args = %w[list]

    use_ui @ui do
      assert_nil @runner.run(args)
    end

    assert_empty @ui.error
  end

  def test_search_succeeds
    args = %w[search]

    use_ui @ui do
      assert_nil @runner.run(args)
    end

    assert_empty @ui.error
  end

  def test_warn_on_outdated
    args = %w[info]
    singleton_gem_class.class_eval do
      def latest_rubygems_version
        Gem::Version.new "99999999.0.0"
      end
    end

    use_ui @ui do
      @runner.run(args)
    end
  end

  private

  def singleton_gem_class
    class << Gem; self; end
  end

end
