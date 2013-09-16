require 'spec_helper'

describe Pannier::App do
  let(:app) { Pannier::App.new }

  it('stores host environment name') do
    expect(Pannier::App.new('foo').host_env).to eq 'foo'
  end
  it('sets root') do
    app.set_root('foo')
    expect(app.root).to eq 'foo'
  end
  it('sets input path') do
    app.set_input('input')
    expect(app.input_path).to match /\/.+\/input/
  end
  it('sets output path') do
    app.set_output('output')
    expect(app.output_path).to match /\/.+\/output/
  end
  it('adds packages') do
    package = mock('Package')
    app.add_package(package)
    expect(app.packages.first).to be package
  end
  describe('#[]') do
    let(:package) { mock('Package', :name => :foo) }
    before(:each) { app.add_package(package) }
    it('finds packages by name') do
      expect(app[:foo]).to be package
    end
    it('returns nil when no package is found') do
      expect(app[:bar]).to be_nil
    end
  end
  describe('#process!') do
    let(:package_1) { mock('Package') }
    let(:package_2) { mock('Package') }
    before(:each) do
      app.add_package(package_1)
      app.add_package(package_2)
    end
    it('calls process on each package') do
      package_1.expects(:process!).once
      package_2.expects(:process!).once
      app.process!
    end
  end
  describe('handler') do
    let(:packages) do
      [
        stub('Package', :handler_path => '/foo', :handler => proc {}),
        stub('Package', :handler_path => '/foo', :handler => proc {}),
        stub('Package', :handler_path => '/bar', :handler => proc {})
      ]
    end
    before(:each) { packages.each { |p| app.add_package(p) } }
    describe('#handler_map') do
      it('has unique keys') do
        expect(app.handler_map.keys).to eq ['/foo', '/bar']
      end
      it('cascades package handlers with same paths') do
        expect(app.handler_map['/foo'].apps.length).to eq 2
      end
    end
    describe('#handler') do
      it('instantiates url map with #handler_map') do
        map = mock('Hash')
        app.stubs(:handler_map).returns(map)
        Rack::URLMap.expects(:new).with(map).once
        app.handler
      end
    end
  end

end
