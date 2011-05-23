class Period

  attr_accessor :task, :start, :stop, :notes

  def initialize(task, start, stop=nil, notes='')
    @task = task
    @start = start
    @stop = stop
    @notes = notes
  end

  def start
    @start.class == Time ? @start : Time.parse(@start)
  end

  def stop
    return nil if @stop.nil?
    @stop.class == Time ? @stop : Time.parse(@stop)
  end

  def length
    stop = self.stop || Time.now
    stop - self.start
  end

  def current?
    self.stop.nil?
  end

end
