autoload 'YamlTimeTrackr', 'timetrackr/yaml'
autoload 'SqliteTimeTrackr', 'timetrackr/sqlite'

class TimeTrackr
  def self.create(type, options={})
    case type.to_s
    when 'yaml'
      begin
        require 'yaml'
        log = YamlTimeTrackr.new(options['path'])
        puts 'Loaded yaml tracker' if $verbose
      rescue LoadError
        puts 'Yaml not found'
      end
    when 'sqlite'
      begin
        require 'sqlite3'
        log = SqliteTimeTrackr.new(options['path'])
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
  # start a period with optional notes
  #
  def start(task,notes)
    raise 'Not implemented'
  end

  #
  # stop a period
  #
  def stop(task)
    raise 'Not implemented'
  end

  #
  # return an array of all tasks
  #
  def tasks
    raise 'Not Implemented'
  end

  #
  # time in task in seconds
  #
  def time(task)
  end

  #
  # get task history as an array of Periods
  #
  def history(task)
    raise 'Not Implemented'
  end

  #
  # clear an task
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

