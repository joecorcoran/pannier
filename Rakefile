require 'bundler/setup'
require 'rspec/core/rake_task'
require "cucumber/rake/task"

RSpec::Core::RakeTask.new('spec')

Cucumber::Rake::Task.new('cuc') do |t|
  t.cucumber_opts = 'features --format progress --tags ~@wip'
end

task :default => %w{spec cuc}
