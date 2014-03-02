require 'spec_helper'
require 'pannier/app'

describe Pannier::App do
  let(:app) { Pannier::App.new }

  it('creates environment') do
    Pannier::Environment.expects(:new).with('production').once
    Pannier::App.new('production')
  end
  it('sets input path') do
    app.set_input('input')
    expect(app.input_path).to match /\/.+\/input/
  end
  it('sets output path') do
    app.set_output('output')
    expect(app.output_path).to match /\/.+\/output/
  end

  describe '#add_package' do
    it('adds package') do
      package = stub('Package')
      app.add_package(package)
      expect(app.packages.first).to be package
    end
  end

  describe('#[]') do
    let(:package) { stub('Package', :name => :foo) }
    before        { app.add_package(package) }
    it('finds packages by name') do
      expect(app[:foo]).to eq package
    end
    it('returns nil when no package is found') do
      expect(app[:bar]).to be_nil
    end
  end

  describe('#process!') do
    let(:package_1) { stub('Package', :name => :foo, :output_assets => []) }
    let(:package_2) { stub('Package', :name => :bar, :output_assets => []) }
    it('calls process! on each package') do
      app.add_package(package_1)
      app.add_package(package_2)
      app.manifest_writer.stubs(:write!)

      package_1.expects(:process!).once
      package_2.expects(:process!).once
      app.process!
    end
    it('writes manifest') do
      app.set_output('output')
      app.manifest_writer.expects(:write!).once
      app.process!
    end
  end

  describe('#process_owners!') do
    let(:package_1) do
      pkg = stub('Package')
      pkg.stubs(:owns_any?).with('/foo/bar.js').returns(true)
      pkg
    end
    let(:package_2) { stub('Package', :owns_any? => false) }
    before(:each) do
      app.add_package(package_1)
      app.add_package(package_2)
    end
    it('calls process! on any package which owns any given path') do
      package_1.expects(:process!).once
      package_2.expects(:process!).never
      app.process_owners!('/foo/bar.js')
    end
  end
end
