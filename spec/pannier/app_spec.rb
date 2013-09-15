require 'spec_helper'

describe Pannier::App do
  let(:app) { Pannier::App.new }

  it('sets input path') do
    app.set_input('input')
    expect(app.input_path).to match /\/.+\/input/
  end
  it('sets output path') do
    app.set_output('output')
    expect(app.output_path).to match /\/.+\/output/
  end
  it('adds packages') do
    package = stub('Package', :name => :foo)
    app.add_package(package)
    expect(app.packages.first).to be package
  end

end
