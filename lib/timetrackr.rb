module TimeTrackr

  require 'time'
  require 'timetrackr/database'
  require 'timetrackr/period'

  autoload 'YamlDatabase', 'timetrackr/yaml'
  autoload 'SqliteDatabase', 'timetrackr/sqlite'
  autoload 'JsonDatabase', 'timetrackr/json'
end
