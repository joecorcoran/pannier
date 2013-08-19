require 'spec_helper'

describe Pannier::App do

  it('sets source path') do
    app = Pannier::App.new do
      source 'assets'
    end
    expect(app.source_path).to eq 'assets'
  end

  describe('package building') do
    let(:app) do
      Pannier::App.new do
        package(:foo)do
        package(:foo) do
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
