require 'spec_helper'
require 'pannier/app'
require 'pannier/tags'
require 'pannier/package'

describe Pannier::Tags do

  let(:app)  { Pannier::App.new }
  let(:tags) { Pannier::Tags.new(app) }

  describe('#new') do
    it('adds default templates') do
      expect(tags.templates.keys).to eq [:js, :css]
    end
  end

  describe('#add_template') do
    it('adds template') do
      tmpl = mock('Template')
      tags.add_template(:foo, tmpl)
      expect(tags.templates[:foo]).to be tmpl
    end
  end

  describe('#write') do
    let(:assets) { [stub_everything, stub_everything] }
    let(:package) { Pannier::Package.new(:bar, app) }
    it('calls template once for each output asset in package') do
      package.stubs(:output_assets => assets)
      app.add_package(package)
      
      tags.templates[:js].expects(:call).twice
      tags.write(:js, :bar)
    end
  end

end
