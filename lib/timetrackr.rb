require 'timetrackr/eventlog'

DEFAULTS = {
  :backend => 'yaml',
  :single_task => false,
  :time_format => "%02dh %02dm %02ds"
}

class TimeTrackr

  def initialize(config)
    @config = DEFAULTS.merge(config || {})
    $verbose = @config[:verbose]
    @log = EventLog.create(@config[:backend])
  end

  def start(args=[])
    return switch(args) if @config[:single_task] && @log.current

    task = args.shift
    notes = args.join(' ')
    puts "Starting task '#{task}'" if $verbose
    @log.event(Time.now, 'start', task, notes)
  end

  def stop(args=[])
    task = args.shift
    if @log.current.include? task
      notes = args.join(' ')
      puts "Stopping task '#{task}'" if $verbose
      @log.event(Time.now, 'stop', task, notes)
    end
  end

  def switch(args=[])
    task = args.shift
    notes = args.join(' ')
    puts "Switching to task '#{task}'" if $verbose
    @log.current.each do |t|
      @log.event(Time.now,'stop',t, notes) unless t == task
    end
    @log.event(Time.now,'start',task, notes)
  end

  def time(task)
    time = @log.time(task).to_i
    hours = time/3600.to_i
    minutes = (time/60 - hours * 60).to_i
    seconds = (time - (minutes * 60 + hours * 3600))
    format(@config[:time_format], hours, minutes, seconds)
  end

  def clear(task)
    puts "Clearing task '#{task}'" if $verbose
    @log.clear(task)
  end

  def current
    puts @log.current.inspect
  end

  def exit
    @log.close
  end
end
