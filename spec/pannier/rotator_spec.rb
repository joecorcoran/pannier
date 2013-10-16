require 'spec_helper'
require 'pannier/rotator'

describe Pannier::Rotator do

  let(:rotator) { Pannier::Rotator.new(fixture_path, 5) }

  before do
    create_fixtures!
    time = Time.new(1984).to_i
    (0..4).each { |i| mkdir("#{time + i}") }
  end
  after { remove_fixtures! }

  describe('#rotate!') do
    before { rotator.rotate!(Time.new(2000)) }
    it('creates new timestamped directory') do
      in_fixtures do
        expect(Dir['*'].sort.last).to eq '946684800'
      end
    end
    it('removes oldest timestamped directory') do
      in_fixtures do
        expect(Dir['*'].sort.first).to eq '441763201'
      end
    end
  end

  describe('#directory_paths') do
    it('returns timestamped directory paths sorted in reverse') do
      basenames = rotator.directory_paths.map { |path| Pathname.new(path).basename.to_s }
      expect(basenames).to eq [
        '441763204',
        '441763203',
        '441763202',
        '441763201',
        '441763200'
      ]
    end
  end

end
