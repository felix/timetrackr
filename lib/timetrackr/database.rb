
module TimeTrackr
  class Database
    def self.create(type, options={})
      case type.to_s
      when 'yaml'
        begin
          require 'yaml'
          db = TimeTrackr::YamlDatabase.new(options['path'])
          puts 'Loaded YAML tracker' if options['verbose']
        rescue LoadError
          puts 'YAML not found'
        end

      when 'sqlite'
        begin
          require 'sqlite3'
          db = TimeTrackr::SqliteDatabase.new(options['path'])
          puts 'Loaded sqlite tracker' if options['verbose']
        rescue LoadError
          puts 'Sqlite not found'
        end

      when 'json'
        begin
          require 'json'
          db = TimeTrackr::JsonDatabase.new(options['path'])
          puts 'Loaded JSON database' if options['verbose']
        rescue LoadError
          puts 'JSON not found'
        end

      else
        raise "Bad log type: #{type}"
      end
      db
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
      raise 'Not implemented'
    end

    #
    # get task history as an array of Periods
    #
    def history(task)
      raise 'Not Implemented'
    end

    #
    # rename a task
    #
    def rename(from, to)
      raise 'Not implemented'
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
end

