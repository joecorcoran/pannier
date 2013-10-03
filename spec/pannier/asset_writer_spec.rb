require 'spec_helper'

describe Pannier::AssetWriter do

  let(:app)          { Pannier::App.new }
  let(:asset_writer) { Pannier::AssetWriter.new(app) }

  describe('#new') do
    it('adds default templates') do
      expect(asset_writer.templates.keys).to eq [:js, :css]
    end
  end

  describe('#add_template') do
    it('adds template') do
      tmpl = mock('Template')
      asset_writer.add_template(:foo, tmpl)
      expect(asset_writer.templates[:foo]).to be tmpl
    end
  end

  describe('#write') do
    let(:assets) { [stub_everything, stub_everything] }
    it('calls template once for each output asset in package') do
      package = mock('Package', :name => :bar, :output_assets => assets)
      app.add_package(package)
      
      asset_writer.templates[:js].expects(:call).twice
      asset_writer.write(:js, :bar)
    end

    it('uses input assets when app host_env is "development"') do
      package = mock('Package', :name => :baz, :input_assets => assets)
      app.add_package(package)
      app.stubs(:host_env => 'development')

      asset_writer.templates[:js].expects(:call).twice
      asset_writer.write(:js, :baz)
    end
  end

end
