require 'bundler/setup'
require 'rspec/core/rake_task'
require "cucumber/rake/task"

RSpec::Core::RakeTask.new('spec')

namespace(:cucumber) do
  Cucumber::Rake::Task.new(:features) do |t|
    t.cucumber_opts = 'features --format progress --tags ~@wip'
  end
  Cucumber::Rake::Task.new(:wip) do |t|
    t.cucumber_opts = 'features --format progress --wip --tags @wip'
  end
end


task :default => %w{spec cucumber:features cucumber:wip}
