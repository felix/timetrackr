autoload 'YamlEventLog', 'timetrackr/eventlog/yaml'
autoload 'SqliteEventLog', 'timetrackr/eventlog/sqlite'

class EventLog
  def self.create(type,options={})
    case type.to_s
    when 'yaml'
      begin
        require 'yaml'
        puts 'Loading yaml eventlog' if $verbose
        YamlEventLog.new(options)
      rescue LoadError
        puts 'Yaml not found'
      end
    when 'sqlite'
      begin
        require 'sqlite3'
        puts 'Loading sqlite eventlog' if $verbose
        SqliteEventLog.new(options)
      rescue LoadError
        puts 'Sqlite not found'
      end
    else
      raise "Bad log type: #{type}"
    end
  end

  #
  # return the list of current tasks
  #
  def current
    raise 'Not Implemented'
  end

  #
  # time in task
  #
  def time(task)
    raise 'Not Implemented'
  end

  #
  # write an event
  #
  def event(time, action, task='default', notes='')
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
