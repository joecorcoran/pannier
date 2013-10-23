require 'spec_helper'
require 'pannier/rotator'

describe Pannier::Rotator do
  let(:rotator) { Pannier::Rotator.new(fixture_path, 5) }

  before do
    create_fixtures!
    time = Time.new(1984).to_i
    (0..3).each { |i| mkdir("#{time + i}") }
  end
  after { remove_fixtures! }

  describe('#rotate') do
    context('always') do
      before { rotator.rotate(Time.new(2000)) }
      it('creates new timestamped directory') do
        in_fixtures { expect(Dir['*'].sort.last).to eq '946684800' }
      end

      it('removes oldest timestamped directory') do
        in_fixtures { expect(Dir['*'].sort.first).to eq '441763200' }
      end

      it('maintains limited number of directories') do
        rotator.rotate(Time.new(2001))
        in_fixtures { expect(Dir['*'].length).to eq 5 }
      end
    end

    context('with block') do
      it('yields newly pushed directory path') do
        rotator.rotate(Time.new(2000)) do |latest|
          expect(latest).to match /\/946684800$/
        end
      end

      it('rolls back changes if block raises error') do
        begin
          rotator.rotate(Time.new(2000)) { |latest| raise RuntimeError }
        rescue RuntimeError
        end
        in_fixtures { expect(Dir['*'].length).to eq 4 }
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
      expect(basenames).to eq [
        '441763203',
        '441763202',
        '441763201',
        '441763200'
      ]
    end
  end
end
