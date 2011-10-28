# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{timetrackr}
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Felix Hanley}]
  s.date = %q{2011-10-28}
  s.email = %q{felix@seconddrawer.com.au}
  s.executables = [%q{timetrackr}]
  s.extra_rdoc_files = [%q{README}]
  s.files = [%q{Rakefile}, %q{Gemfile}, %q{Gemfile.lock}, %q{LICENSE}, %q{README}, %q{CHANGELOG}, %q{Manifest}, %q{TODO}, %q{bin/timetrackr}, %q{test/helper.rb}, %q{test/test_timetrackr.rb}, %q{lib/timetrackr}, %q{lib/timetrackr/period.rb}, %q{lib/timetrackr/database.rb}, %q{lib/timetrackr/cli.rb}, %q{lib/timetrackr.rb}]
  s.homepage = %q{http://github.com/felix/timetrackr}
  s.rdoc_options = [%q{--main}, %q{README}]
  s.require_paths = [%q{lib}]
  s.rubygems_version = %q{1.8.5}
  s.summary = %q{A simple time tracking utility}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
