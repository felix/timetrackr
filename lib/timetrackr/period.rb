class Period

  attr_accessor :task, :start, :stop, :notes

  def initialize(task, start, stop=nil, notes='')
    @task = task
    @start = start
    @stop = stop
    @notes = notes
  end

  def length
    stop = @stop || Time.now
    stop - @start
  end

  def current?
    @stop.nil?
  end

end
