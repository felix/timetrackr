require 'helper'

class TestTimetrackr < Test::Unit::TestCase
  context 'a YAML based tracker' do
    setup do
      @config = {:path => '/tmp/timetracker.test'}
      @t = TimeTrackr.create('yaml',@config)
    end

    def teardown
      File.unlink(@config[:path]) rescue nil
    end

    should 'initialise a log file' do
      assert File.exist?(@config[:path])
    end

    context 'with empty db' do
      setup do
        File.open(@config[:path]) do |fh|
          @db = YAML.load(fh)
        end
      end

      should 'create basic structure' do
        File.open(@config[:path]) do |fh|
          @db = YAML.load(fh)
        end
        assert @db[:current].class == Array
        assert @db[:tasks].class == Hash
      end

      should 'not fail on current command' do
        assert_nothing_raised Exception do
          @t.current
        end
      end

      should 'not fail on tasks command' do
        assert_nothing_raised Exception do
          @t.tasks
        end
      end

      should 'not fail on close command' do
        assert_nothing_raised Exception do
          @t.close
        end
      end

    end
  end

  context 'an Sqlite based tracker' do
    setup do
      @config = {:path => '/tmp/timetracker.test'}
      @t = TimeTrackr.create('sqlite',@config)
    end

    def teardown
      File.unlink(@config[:path]) rescue nil
    end

    should 'initialise a log file' do
      assert File.exist?(@config[:path])
    end

    context 'with empty db' do

      should 'not fail on current command' do
        assert_nothing_raised Exception do
          @t.current
        end
      end

      should 'not fail on tasks command' do
        assert_nothing_raised Exception do
          @t.tasks
        end
      end

      should 'not fail on close command' do
        assert_nothing_raised Exception do
          @t.close
        end
      end

    end
  end
end
