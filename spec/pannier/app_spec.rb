require 'spec_helper'

describe Pannier::App do
  it('sets source path') do
    app = Pannier::App.new do
      source File.join(FileHelper.fixture_path, 'source')
    end
    expect(app.source_path).to eq File.join(FileHelper.fixture_path, 'source')
  end

  it('sets result path') do
    app = Pannier::App.new do
      result File.join(FileHelper.fixture_path, 'packaged')
    end
    expect(app.result_path).to eq File.join(FileHelper.fixture_path, 'packaged')
  end

  describe('package building') do
    let(:app) do
      Pannier::App.new do
        package('foo') do
        end
      end
    end
    it('adds packages') do
      expect(app.packages.length).to eq 1
    end
    it('passes self to packages') do
      expect(app.packages.first.app).to eq app
    end
  end

end
