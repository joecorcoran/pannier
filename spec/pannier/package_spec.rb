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
  it('sets source path') do
    package.set_source('stylesheets')
    expect(package.source_path).to eq 'stylesheets'
  end
  it('builds full source path') do
    app.stubs(:source_path => '/foo/bar/source')
    package.set_source('stylesheets')
    expect(package.full_source_path).to eq '/foo/bar/source/stylesheets'
  end
  it('sets result path') do
    package.set_result('stylesheets')
    expect(package.result_path).to eq 'stylesheets'
  end
  it('builds full result path') do
    app.stubs(:result_path => '/foo/bar/processed')
    package.set_result('stylesheets')
    expect(package.full_result_path).to eq '/foo/bar/processed/stylesheets'
  end

end
