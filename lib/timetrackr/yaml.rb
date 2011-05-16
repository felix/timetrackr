class YamlTimeTrackr < TimeTrackr

  def initialize(path)
    @log_path = path
    if !File.exist? @log_path
      @db = {:current => [], :tasks => {}}
      write_file
    end
    @db = YAML.load_file(@log_path)
    puts "Using log file '#{@log_path}'" if $verbose
  end

  def current
    @db[:current]
  end

  def tasks
    @db[:tasks].keys.compact.uniq || []
  end

  def time(task)
    total = 0 # seconds
    split = nil
    @db[:tasks][task].sort{|x,y| x[:time] <=> y[:time]}.each do |event|
      if event[:action] == 'start'
        split = event[:time]
      end
      if split && (event[:action] == 'stop')
        total = total + (event[:time] - split)
        split = nil
      end
    end
    total = (total + (Time.now - split)) if split
    total.to_i
  end

  def event(task='default', time=Time.now, details={})
    details[:action] ||= 'start'
    details[:time] = time
    if details[:action].to_s == 'stop' && @db[:current].delete(task)
      write_event(task,details)
    end

    if details[:action].to_s == 'start' && !@db[:current].include?(task)
      @db[:current].unshift(task)
      write_event(task,details)
    end
  end

  def close
    write_file
  end

  def clear(task)
    @db[:current].delete(task)
    @db[:tasks].delete(task)
  end

  private

  def write_event(task, details)
    @db[:tasks] = {} unless @db[:tasks]
    if @db[:tasks][task]
      @db[:tasks][task].push(details)
    else
      @db[:tasks][task] = Array[details]
    end
  end

  def write_file
    File.open(@log_path,'w') do |fh|
      YAML.dump(@db,fh)
    end
  end
end
