require 'spec_helper'
require 'pannier/app'
require 'pannier/tags'
require 'pannier/package'

describe Pannier::Tags do

  let(:app)  { Pannier::App.new }
  let(:tags) { Pannier::Tags.new(app) }

  describe('#write') do
    it('calls template once for each output asset in package') do
      package  = Pannier::Package.new(:js, app)
      package.stubs(:output_assets => [stub_everything, stub_everything])
      app.add_package(package)

      template = mock('Pannier::Tags::JavaScript')
      Pannier::Tags::JavaScript.stubs(:new => template)
      
      template.expects(:call).twice
      
      tags.write(:js, :as => Pannier::Tags::JavaScript)
    end
  end

end
