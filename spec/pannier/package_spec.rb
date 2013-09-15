require 'spec_helper'

describe Pannier::Package do
  let(:app) { stub('App') }
  let(:package) { Pannier::Package.new(:foo, app) }

  it('has name') do
    expect(package.name).to eq :foo
  end
  it('has parent app') do
    expect(package.app).to eq app
  end
  it('sets input path') do
    package.set_input('stylesheets')
    expect(package.input_path).to eq 'stylesheets'
  end
  it('builds full input path') do
    app.stubs(:input_path => '/foo/bar/input')
    package.set_input('stylesheets')
    expect(package.full_input_path).to eq '/foo/bar/input/stylesheets'
  end
  it('sets output path') do
    package.set_output('stylesheets')
    expect(package.output_path).to eq 'stylesheets'
  end
  it('builds full output path') do
    app.stubs(:output_path => '/foo/bar/output')
    package.set_output('stylesheets')
    expect(package.full_output_path).to eq '/foo/bar/output/stylesheets'
  end

end
