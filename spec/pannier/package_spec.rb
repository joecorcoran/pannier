require 'spec_helper'

describe Pannier::Package do
  ASSET_DIR = File.join(Dir.getwd, 'spec', 'assets')

  let(:app) do
    Pannier::App.new do
      source ASSET_DIR
    end
  end
  let(:package) { Pannier::Package.new(:foo, app) }

  it('stores name') do
    expect(package.name).to eq :foo
  end
  it('stores parent app') do
    expect(package.app).to eq app
  end
  describe('paths') do
    before(:each) { package.source 'stylesheets' }
    it('sets source path') do
      expect(package.source_path).to eq 'stylesheets'
    end
    it('has full path') do
      expect(package.full_path).to match(File.join(ASSET_DIR, 'stylesheets'))
    end
  end
  describe('source file lookup') do
    before(:each) do
      package.source 'stylesheets'
      package.assets '**/*.css', 'one*'
    end
    it('globs files, only stores unique paths') do
      expect(package.asset_paths.length).to eq 3
    end
    it('looks in joined source directory') do
      expect(package.asset_paths.first).to match package.full_path
    end
  end

end
