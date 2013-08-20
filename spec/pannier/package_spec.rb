require 'spec_helper'

describe Pannier::Package do
  let(:app) do
    Pannier::App.new do
      source File.join(FileHelper.fixture_path, 'source')
      result File.join(FileHelper.fixture_path, 'processed')
    end
  end
  let(:package) do
    Pannier::Package.new('foo', app) do
      source 'stylesheets'
      result 'stylesheets'
    end
  end

  it('stores name') do
    expect(package.name).to eq 'foo'
  end
  it('stores parent app') do
    expect(package.app).to eq app
  end
  it('sets source path') do
    expect(package.source_path).to match(
      File.join(FileHelper.fixture_path, 'source', 'stylesheets')
    )
  end
  it('sets source path') do
    expect(package.result_path).to match(
      File.join(FileHelper.fixture_path, 'processed', 'stylesheets')
    )
  end

  describe('source file lookup') do
    before(:each) do
      package.assets '**/*.css', 'one*', './two.css'
    end
    it('globs files, only stores unique assets') do
      expect(package.asset_set.length).to eq 3
    end
  end
  describe('processing') do
    let(:style_path) { File.join(FileHelper.fixture_path, 'processed', 'stylesheets') }
    before(:each) do
      package.assets '**/*.css'
    end
    after(:each) do
      FileHelper.clean_processed_files!
    end
    it('copies files to result directory by default') do
      package.run!
      pattern = File.join(style_path, '**/*.css')
      expect(Dir[pattern].length).to eq 3
    end
    it('runs process proc if provided') do
      package.process do |assets|
        assets.map do |a|
          a.pipe { |contents| "/* comment */\n" << contents }
        end
      end
      package.run!
      processed_data = File.read(File.join(style_path, 'one.css'))
      expect(processed_data).to match /\A\/\* comment \*\/\n/
    end
  end

end
