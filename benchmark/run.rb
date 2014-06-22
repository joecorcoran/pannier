require 'benchmark'

$LOAD_PATH.unshift(File.expand_path('../../lib', __FILE__))
require 'pannier'

require_relative '../features/support/file_helper'
include FileHelper

def setup!
  create_fixtures!

  mkdir('input')
  mkdir('input/one')
  mkdir('input/two')
  mkdir('input/three')
  mkdir('output')

  in_fixtures do
    30.times { |n| generate_file!('input/one', n) }
    30.times { |n| generate_file!('input/two', n) }
    30.times { |n| generate_file!('input/three', n) }
  end
end

def teardown!
  remove_fixtures!
end

def generate_file!(dir, n)
  File.open("#{dir}/styles-#{n}.css", 'w+') do |file|
    file << ".some-class-#{n} { font-size: #{n}%; }\n"
  end
end

trap('SIGINT') do
  teardown!
  exit
end

setup!
Benchmark.bmbm(20) do |x|
  x.report('separate input') do
    1000.times do
      Pannier.load('config_separate.rb', 'benchmarking').process!
    end
  end
  x.report('shared input') do
    1000.times do
      Pannier.load('config_shared.rb', 'benchmarking').process!
    end
  end
end
teardown!
