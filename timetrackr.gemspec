# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{timetrackr}
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Felix Hanley"]
  s.date = %q{2011-05-17}
  s.default_executable = %q{timetrackr}
  s.description = %q{A simple time tracking utility}
  s.email = %q{felix@seconddrawer.com.au}
  s.executables = ["timetrackr"]
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.mkd"
  ]
  s.files = [
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.mkd",
    "Rakefile",
    "VERSION",
    "bin/timetrackr",
    "lib/timetrackr.rb",
    "lib/timetrackr/period.rb",
    "lib/timetrackr/yaml.rb",
    "test/helper.rb",
    "test/test_timetrackr.rb",
    "timetrackr.gemspec"
  ]
  s.homepage = %q{http://github.com/felix/timetrackr}
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{A simple time tracking utility}
  s.test_files = [
    "test/helper.rb",
    "test/test_timetrackr.rb"
  ]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<shoulda>, [">= 0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.5.2"])
      s.add_development_dependency(%q<rcov>, [">= 0"])
    else
      s.add_dependency(%q<shoulda>, [">= 0"])
      s.add_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.5.2"])
      s.add_dependency(%q<rcov>, [">= 0"])
    end
  else
    s.add_dependency(%q<shoulda>, [">= 0"])
    s.add_dependency(%q<bundler>, ["~> 1.0.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.5.2"])
    s.add_dependency(%q<rcov>, [">= 0"])
  end
end

