#
# keeps the following format in a yaml file:
#
# :current: []
#
# :tasks:
#   foo:
#   - :start: 2011-05-16 14:26:26.263449 +07:00
#     :stop: 2011-05-16 14:26:27 +07:00
#     :notes: "blah blah blah"
#

module TimeTrackr
  class Database
    def initialize(options={})
      @options = options
      begin
        require 'yaml'
        @log_path = options['path']
        if !File.exist? @log_path
          @db = {:current => [], :tasks => {}}
          write_file
        end
        @db = YAML.load_file(@log_path)
        puts 'Loaded database' if options['verbose']
      rescue LoadError
        puts 'YAML not found'
      end
    end

    #
    # return an array of current tasks
    #
    def current
      @db[:current]
    end

    #
    # return an array of all tasks
    #
    def tasks
      @db[:tasks].keys.compact.uniq || []
    end

    #
    # start a period with optional notes
    #
    def start(task, notes)
      @db[:tasks][task] = Array[] unless @db[:tasks][task]
      if !@db[:current].include?(task)
        @db[:current].unshift(task)
        @db[:tasks][task].push({:start => Time.now, :notes => notes})
      end
    end

    #
    # stop a period
    #
    def stop(task)
      if @db[:current].include?(task)
        @db[:current].delete(task)
        @db[:tasks][task].last[:stop] = Time.now
      end
    end

    #
    # get task history as an array of Periods
    #
    def history(task, p_begin=nil, p_end=nil)
      @db[:tasks][task].sort{|x,y| x[:start] <=> y[:start]}.collect {|p|
        Period.new(task,p[:start],p[:stop],p[:notes])
      } unless !@db[:tasks].include? task
    end

    #
    # rename a task
    #
    def rename(from, to)
      @db[:tasks][to] = @db[:tasks].delete(from)
      if @db[:current].delete(from)
        @db[:current].unshift(to)
      end
    end

    #
    # cleanup and close
    #
    def close
      write_file
    end

    #
    # clear an task
    #
    def clear(task)
      @db[:current].delete(task)
      @db[:tasks].delete(task)
    end

    private

    def write_file
      File.open(@log_path,'w') do |fh|
        YAML.dump(@db,fh)
        puts 'Saved database' if @options['verbose']
      end
    end
  end
end
