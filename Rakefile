require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "payment_dta"
    gem.summary = "Ruby library to generate Swiss DTA payment files"
    gem.description = "Generate Swiss DTA payment files to extract payments from your existing application"
    gem.email = "patrick.huesler@gmail.com"
    gem.homepage = "http://github.com/phuesler/payment_dta"
    gem.authors = ["Patrick Huesler"]
    gem.files = FileList[
      "lib/**/*.rb",
      "generators/**/*",
      "LICENSE",
      "README.rdoc",
      "VERSION",
      "script/*"
    ]
    gem.test_files = FileList[
      "spec/**/*.rb"
    ]
    gem.add_development_dependency "rspec"
    gem.add_development_dependency "rubigen"
    gem.add_development_dependency 'jeweler'
    gem.add_development_dependency 'rake'
    gem.add_development_dependency 'simplecov'
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
end

task :default => :spec

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION')
    version = File.read('VERSION')
  else
    version = ""
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "payment_dta #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
