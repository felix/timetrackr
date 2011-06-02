module TimeTrackr
  class CLI
    DEFAULTS = {
      'backend' => 'yaml',
      'verbose' => false,
      'single_task' => false,
      'path' => File.join(ENV['HOME'],'.timetrackr.db'),
      'relative_format' => "%2<hours>dh %2<minutes>dm %2<seconds>ds",
      'absolute_time' => "%H:%M",
      'absolute_day' => "%Y-%m-%d"
    }

    #
    # static method to get config file and run the tracker
    #
    def self.run(args)
      config = {}
      config_file = File.join(ENV['HOME'],'.timetrackrrc')
      if File.exist?(config_file)
        require 'yaml'
        config = YAML.load_file(config_file)
      end

      # global options
      while (cmd = args.shift) && cmd.start_with?('-')
        if ['-v','--verbose'].include? cmd
          config['verbose'] = true
        end
        if ['-h','--help'].include? cmd
          cmd = 'help'
        end
      end
      config = DEFAULTS.merge(config || {})

      cli = TimeTrackr::CLI.new(config)
      cli.run(cmd, args)
    end

    def initialize(config)
      @config = config
      @verbose = config['verbose']
      @trackr = TimeTrackr::Database.create(config['backend'], config)
    end

    #
    # run a command on the tracker
    # 'args' is everything after the command
    #
    def run(cmd,args)
      case cmd
      when 'start','in','s'
        task = args.shift
        notes = args.join(' ')
        # switch tasks if config says so
        if @config['single_task'] && @trackr.current != task
          @trackr.current.each { |t|
            @trackr.stop(t) unless t == task
          }
          puts "Switched to task '#{task}'" if @verbose
        else
          puts "Started task '#{task}'" if @verbose
        end
        @trackr.start(task, notes)

      when 'stop','out','kill','k'
        tasks = get_tasks(args)
        tasks.each do |task|
          @trackr.stop(task)
          puts "Stopped task '#{task}'" if @verbose
        end

      when 'switch','sw'
        task = args.shift
        notes = args.join(' ')
        @trackr.current.each do |t|
          @trackr.stop(t) unless t == task
        end
        @trackr.start(task, notes)
        puts "Switched to task '#{task}'" if @verbose

      when 'time','status',nil
        tasks = get_tasks(args)
        puts create_log(tasks,'t')

      when 'log'
        group = args.shift[1] if ['-d','-t'].include?(args[0])

        tasks = get_tasks(args)
        puts create_log(tasks,group)

      when 'clear','delete','del'
        tasks = get_tasks(args)
        tasks.each do |task|
          @trackr.clear(task)
          puts "Task '#{task}' cleared" if @verbose
        end

      when 'rename','mv'
        from = args.shift
        to = args.shift
        @trackr.rename(from,to)
        puts "Renamed '#{from}' to '#{to}'" if @verbose

      when 'help'
        show_help

      else
        puts "'#{cmd}' is not a valid command"
        show_help
      end

      @trackr.close
    end

    protected

    def get_tasks(args)
      if args[0].nil? || args[0] == 'all' || args[0] == '-n'
        args.unshift(@trackr.tasks).flatten!.delete('all')
      end

      split = args.index('-n') || args.length
      show = args.slice(0...split).compact.uniq
      ignore =[*args.slice(split+1..-1)].compact.uniq
      tasks = (show.empty? ? @trackr.tasks : @trackr.tasks & show) - ignore
    end

    def format_time(time, fmt_str)
      hours = time.to_i/3600.to_i
      minutes = (time/60 - hours * 60).to_i
      seconds = (time - (minutes * 60 + hours * 3600))
      format(fmt_str,{
        :hours => hours,
        :minutes => minutes,
        :seconds => seconds})
    end

    def create_log(tasks,group=nil)
      totals = Hash.new(0)
      days = {}
      table = []
      # get all periods for selected tasks
      periods = tasks.each.collect{ |t| @trackr.history(t) }.flatten
      lastday = nil
      periods.sort{|x,y| x.start <=> y.start}.collect do |period|
        currday = period.start.strftime(@config['absolute_day'])
        if currday == lastday
          day = ''
        else
          day = currday
          days[day] = Hash.new(0)
        end
        lastday = currday

        start = period.start.strftime(@config['absolute_time'])
        stop = period.current? ? ' ' : period.stop.strftime(@config['absolute_time'])
        name = period.current? ? period.task+' *' : period.task
        notes = period.notes
        length = format_time(period.length, @config['relative_format'])

        totals[period.task] = totals[period.task] + period.length if group == 't'
        days[currday][period.task] = days[currday][period.task] + period.length if group == 'd'
        # for full log
        table << "#{day.ljust(12)} #{name.ljust(15)} #{start} - #{stop.ljust(5)}  #{length}  #{notes}" if group.nil?
      end

      case group
      when 't'
        tasks.each do |task|
          name = @trackr.current.include?(task) ? task+' *' : task
          table <<  name.ljust(15) + format_time(totals[task],@config['relative_format'])
        end
      when 'd'
        prev_date = ''
        days.each_pair do |date,tasks|
          tasks.each_pair do |task,length|
            name = @trackr.current.include?(task) ? task+' *' : task
            date_string = (date == prev_date) ? ' ' : date
            prev_date = date
            table << "#{date_string.ljust(12)} #{name.ljust(15)}  " + format_time(length, @config['relative_format'])
          end
        end
      end
      table
    end

    def show_help
      version = File.exist?('VERSION') ? File.read('VERSION') : ""
      puts "timetrackr version #{version}"
      puts <<HELP

  timetrackr [command] [options]

  Available commands:

      start [task]   start a task
      stop [task]    stop a task (or 'all')
      switch TASK    switch tasks
      time [task]    show time for a task (or 'all')
      log [task]     show time log for a task (or 'all')

  Global options
      -h --help      show this help
      -v --verbose   be noisy
HELP
    end
  end
end
