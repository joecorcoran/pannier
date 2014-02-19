require 'spec_helper'
require 'pannier/rotator'

describe Pannier::Rotator do
  let(:limit)   { 3 }
  let(:rotator) { Pannier::Rotator.new(fixture_path, limit) }
  let(:timestamps) do
    time  = Time.new(1984).to_i
    times = (time..(time + 2))
    times.map(&:to_s)
  end

  before do
    create_fixtures!
    timestamps.each { |t| mkdir(t) }
  end
  after { remove_fixtures! }

  describe('#rotate') do
    context('always') do
      before { rotator.rotate(Time.new(2000)) }
      it('creates new timestamped directory') do
        in_fixtures { expect(Dir['*'].sort.last).to eq Time.new(2000).to_i.to_s }
      end

      it('removes oldest timestamped directory') do
        in_fixtures { expect(Dir['*'].sort.first).to eq timestamps[1] }
      end

      it('maintains limited number of directories') do
        in_fixtures { expect(Dir['*'].length).to eq limit }
      end
    end

    context('with block') do
      it('yields newly pushed directory path') do
        rotator.rotate(Time.new(2000)) do |latest|
          expect(latest).to match /\/#{Time.new(2000).to_i}$/
        end
      end

      it('rolls back changes if block raises error') do
        begin
          rotator.rotate(Time.new(2000)) { |latest| raise RuntimeError }
        rescue RuntimeError
        end
        in_fixtures { expect(Dir['*'].length).to eq limit }
      end

      it('raises error if block raises error') do
        expect {
          rotator.rotate(Time.new(2000)) { |latest| raise 'Something happened' }
        }.to raise_error(RuntimeError, 'Something happened')
      end
    end
  end

  describe('#directory_paths') do
    it('returns timestamped directory paths sorted in reverse') do
      basenames = rotator.directory_paths.map do |path|
        Pathname.new(path).basename.to_s
      end
      expect(basenames).to eq timestamps.reverse
    end
  end
end
