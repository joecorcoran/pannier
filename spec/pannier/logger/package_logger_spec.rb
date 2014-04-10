require 'stringio'

require 'spec_helper'
require 'pannier/logger'
require 'pannier/package'

describe Pannier::Logger::PackageLogger do

  let(:stdout)     { StringIO.new }
  let(:logger)     { Pannier::Logger.new(stdout) }
  let(:package)    { stub }
  let(:pkg_logger) { Pannier::Logger::PackageLogger.new(logger, package) }

  describe('#log!') do
    it('writes messages') do
      pkg_logger.log!(['Hello', 'World'])
      expect(stdout.string).to eq "Hello\nWorld\n"
    end
    it('writes messages with indentation') do
      pkg_logger.log!(['Hello', 'World'], 2)
      expect(stdout.string).to eq "  Hello\n  World\n"
    end
    it('does not write messages if no logger is set') do
      pkg_logger = Pannier::Logger::PackageLogger.new(nil, package)
      pkg_logger.log!(['Hello'])
      expect(stdout.string).to be_empty
    end
  end

  describe('logging') do
    let(:assets) do
      [stub('Asset', :path => 'bar'), stub('Asset', :path => 'baz')]
    end
    describe('#log_input!') do
      before do
        package.stubs(:name => :foo, :input_assets => assets)
        pkg_logger.log_input!
      end

      it('logs package name') do
        expect(stdout.string).to match /\:foo/
      end
      it('logs input asset paths') do
        expect(stdout.string).to match /bar\s+baz/
      end
    end
    describe('#log_output!') do
      it('logs output asset paths') do
        package.stubs(:output_assets => assets)
        pkg_logger.log_output!
        expect(stdout.string).to match /bar\s+baz/
      end
    end
  end

  describe('#wrap') do
    it('logs input, then yields, then logs output') do
      wrapping = sequence('wrapping')
      other    = mock

      pkg_logger.expects(:log_input!).in_sequence(wrapping).once
      other.expects(:foo).in_sequence(wrapping).once
      pkg_logger.expects(:log_output!).in_sequence(wrapping).once

      pkg_logger.wrap { other.foo }
    end
  end

end
