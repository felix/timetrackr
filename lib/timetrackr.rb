autoload 'YamlTimeTrackr', 'timetrackr/yaml'
autoload 'SqliteTimeTrackr', 'timetrackr/sqlite'

class TimeTrackr
  def self.create(type,options={})
    case type.to_s
    when 'yaml'
      begin
        require 'yaml'
        log = YamlTimeTrackr.new(options[:path])
        puts 'Loaded yaml tracker' if $verbose
      rescue LoadError
        puts 'Yaml not found'
      end
    when 'sqlite'
      begin
        require 'sqlite3'
        log = SqliteTimeTrackr.new(options[:path])
        puts 'Loaded sqlite tracker' if $verbose
      rescue LoadError
        puts 'Sqlite not found'
      end
    else
      raise "Bad log type: #{type}"
    end
    log
  end

  #
  # return an array of current tasks
  #
  def current
    raise 'Not Implemented'
  end

  #
  # return an array of all tasks
  #
  def tasks
    raise 'Not Implemented'
  end

  #
  # time in task in seconds
  # only considers 'start' and 'stop' events
  #
  def time(task)
    raise 'Not Implemented'
  end

  #
  # write an event
  #
  def event(task, time=Time.now, details={})
    raise 'Not Implemented'
  end

  #
  # clear an event
  #
  def clear(task)
    raise 'Not Implemented'
  end

  #
  # cleanup and close
  #
  def close
  end

end

