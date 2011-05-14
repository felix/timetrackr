class YamlEventLog < EventLog

  def initialize(options)
    @log_path = options[:log_path] || File.join(ENV['HOME'],'.timetrackr.db')
    puts "Using log file '#{@log_path}'" if $verbose
    if File.exist? @log_path
      @db = YAML.load_file(@log_path)
    else
      @db = {:current => []}
    end
  end

  def current
    @db[:current]
  end

  def time(task)
    total = 0 # seconds
    split = nil
    @db[task].each do |event|
      if event[:action] == 'start'
        split = event[:time]
      end
      if split && (event[:action] == 'stop')
        total = total + (event[:time] - split)
        split = nil
      end
    end
    total = (total + (Time.now - split)) if split
    total
  end

  def event(time, action, task='default', notes='')

    if action.to_s == 'stop' && @db[:current].delete(task)
      write_event({:task => task,
                  :time => time,
                  :action => action,
                  :notes => notes })
    end

    if action.to_s == 'start' && !@db[:current].include?(task)
      @db[:current].unshift(task)
      write_event({:task => task,
                  :time => time,
                  :action => action,
                  :notes => notes })
    end
  end

  def close
    puts "Closing #{@log_path}" if $verbose
    File.open(@log_path,'w') do |fh|
      YAML.dump(@db,fh)
    end
  end

  def clear(task)
    @db[:current].delete(task)
    @db.delete(task)
  end

  private

  def write_event(details)
    if @db[details[:task]]
      @db[details[:task]].push(details)
    else
      @db[details[:task]] = Array[details]
    end
  end
end
