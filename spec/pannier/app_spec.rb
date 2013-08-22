require 'spec_helper'

describe Pannier::App do
  let(:app) do
    Pannier::App.new do
      source 'source'
      result 'processed'
    end
  end

  it('sets source path') do
    expect(app.source_path).to match /\/.+\/source/
  end
  it('sets result path') do
    expect(app.result_path).to match /\/.+\/processed/
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
