class SqliteTimeTrackr < TimeTrackr

  def initialize(path)
    @log_path = path
    if !File.exist? @log_path
      @db = SQLite3::Database.new(@log_path)
      sql_events = "CREATE TABLE events (
      id INTEGER AUTO_INCREMENT PRIMARY KEY,
      task VARCHAR(50),
      start DATETIME,
      stop DATETIME,
      notes VARCHAR(255));"
      @db.execute(sql_events)
    else
      @db = SQLite3::Database.open(@log_path)
    end
    @db.type_translation = true
    puts "Using DB file '#{@log_path}'" if $verbose
  end

  def current
    sql = "SELECT DISTINCT task FROM events WHERE stop IS NULL;"
    @db.execute(sql).collect{|row|
      row.first
    }
  end

  def tasks
    sql = "SELECT DISTINCT task FROM events;"
    @db.execute(sql).collect{ |row|
      row.first
    }
  end

  def start(task, notes)
    sql = "SELECT id FROM events WHERE task = :task AND stop IS NULL;"
    exists = @db.get_first_value(sql, 'task' => task)
    if !exists
      sql = "INSERT INTO events (task,start,notes) VALUES (:task,:start,:notes);"
      @db.execute(sql,'task' => task, 'start' => Time.now.to_s, 'notes' => notes)
    end
  end

  def stop(task)
    sql = "SELECT id FROM events WHERE task = :task AND stop IS NULL;"
    exists = @db.get_first_value(sql, 'task' => task).first
    if exists
      sql = "UPDATE events SET stop = :stop WHERE id = :current;"
      @db.execute(sql, 'current' => exists, 'stop' => Time.now.to_s)
    end
  end

  def history(task, p_begin=nil, p_end=nil)
    sql = "SELECT start, stop, notes FROM events WHERE task = :task ORDER BY start;"
    @db.execute(sql,'task' => task).collect{ |row|
      Period.new(task,row[0],row[1],row[2])
    }
  end

  def clear(task)
    sql = "DELETE FROM events WHERE task = :task;"
    @db.execute(sql, 'task' => task)
  end

end
