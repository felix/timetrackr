module TimeTrackr
  class JsonDatabase < TimeTrackr::Database

    def initialize(path)
      @log_path = path
      if !File.exist? @log_path
        @db = {'current' => [], 'tasks' => {}}
        write_file
      end
      File.open(@log_path,'r') do |fh|
        @db = JSON.load(fh)
      end
    end

    def current
      @db['current']
    end

    def tasks
      @db['tasks'].keys.compact.uniq || []
    end

    def start(task, notes)
      @db['tasks'][task] = Array[] unless @db['tasks'][task]
      if !@db['current'].include?(task)
        @db['current'].unshift(task)
        @db['tasks'][task].push({'start' => Time.now, 'notes' => notes})
      end
    end

    def stop(task)
      if @db['current'].include?(task)
        @db['current'].delete(task)
        @db['tasks'][task].last['stop'] = Time.now
      end
    end

    def history(task, p_begin=nil, p_end=nil)
      @db['tasks'][task].sort{|x,y| x['start'] <=> y['start']}.collect {|p|
        Period.new(task,p['start'],p['stop'],p['notes'])
      } unless !@db['tasks'].include? task
    end

    def rename(from, to)
      @db['tasks'][to] = @db['tasks'].delete(from)
      if @db['current'].delete(from)
        @db['current'].unshift(to)
      end
    end

    def close
      write_file
    end

    def clear(task)
      @db['current'].delete(task)
      @db['tasks'].delete(task)
    end

    private

    def write_file
      File.open(@log_path,'w') do |fh|
        JSON.dump(@db,fh)
      end
    end
  end
end
