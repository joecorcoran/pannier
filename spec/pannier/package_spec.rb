require 'spec_helper'

describe Pannier::Package do
  let(:app) do
    Pannier::App.new do
      source 'source'
      result 'processed'
    end
  end
  let(:package) do
    Pannier::Package.new(:foo, app) do
      source 'stylesheets'
      result 'stylesheets'
    end
  end

  it('stores name') do
    expect(package.name).to eq :foo
  end
  it('stores parent app') do
    expect(package.app).to eq app
  end
  it('sets source path') do
    expect(package.source_path).to eq 'stylesheets'
  end
  it('sets full source path') do
    expect(package.full_source_path).to match /\/.+\/source\/stylesheets/
  end
  it('set result path') do
    expect(package.result_path).to eq 'stylesheets'
  end
  it('sets full result path') do
    expect(package.full_result_path).to match /\/.+\/processed\/stylesheets/
  end

end
