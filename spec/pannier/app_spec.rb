require 'spec_helper'

describe Pannier::App do
  let(:app) { Pannier::App.new }

  it('sets source path') do
    app.set_source('source')
    expect(app.source_path).to match /\/.+\/source/
  end
  it('sets result path') do
    app.set_result('processed')
    expect(app.result_path).to match /\/.+\/processed/
  end
  it('adds packages') do
    package = stub('Package', :name => :foo)
    app.add_package(package)
    expect(app.packages.first).to be package
  end

end
