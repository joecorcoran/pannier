require 'spec_helper'

describe Pannier::Package do
  ASSET_DIR = File.join(Dir.getwd, 'spec', 'assets')

  let(:app) do
    Pannier::App.new do
      source ASSET_DIR
    end
  end

  it('stores parent app') do
    package = Pannier::Package.new(app)
    expect(package.app).to eq app
  end
  describe('paths') do
    let(:package) do
      Pannier::Package.new(app) do
        source 'stylesheets'
      end
    end
    it('sets source path') do
      expect(package.source_path).to eq 'stylesheets'
    end
    it('has full path') do
      expect(package.full_path).to match(File.join(ASSET_DIR, 'stylesheets'))
    end
  end
  describe('source file lookup') do
    let(:package) do
      Pannier::Package.new(app) do
        source 'stylesheets'
        assets '**/*.css', 'one*'
      end
    end
    it('globs files, only stores unique paths') do
      expect(package.asset_paths.length).to eq 3
    end
    it('looks in joined source directory') do
      expect(package.asset_paths.first).to match package.full_path
    end
  end

end
