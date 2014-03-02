require 'spec_helper'
require 'pannier/mounted/app'

describe Pannier::App do
  let(:app) { Pannier::App.new }

  describe('#prime!') do
    let(:package) { stub('Package', :name => :qux) }
    let(:paths)   { ['/output/bar.css', '/output/baz.css'] }
    before do
      app.add_package(package)
    end
    it('builds assets for each package in manifest') do
      package.expects(:build_assets_from_paths).with(paths).once
      package.expects(:add_output_assets).once
      app.prime!({ :qux => paths })
    end
  end

  describe('handler') do
    before(:each) do
      ['foo', 'foo', 'bar'].each_with_index do |output, idx|
        pkg = Pannier::Package.new(:"pkg-#{idx}", app)
        pkg.set_output(output)
        app.add_package(pkg)
      end
    end

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
        map = {}
        app.stubs(:handler_map).returns(map)
        Rack::URLMap.expects(:new).with(map).once
        app.handler
      end
    end
  end
end
