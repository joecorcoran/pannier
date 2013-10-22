require 'spec_helper'
require 'pannier/asset'
require 'pannier/concatenator'
require 'pannier/package'

describe Pannier::Package do
  let(:app) { mock('App') }
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
  
  context('default mode (non-development)') do
    it('delegates assets to output assets') do
      package.expects(:output_assets).once
      package.assets
    end
    it('delegates path to output path') do
      package.expects(:output_path).once
      package.path
    end
    it('delegates full_path to full output path') do
      package.expects(:full_output_path).once
      package.full_path
    end
    it('builds handler path from output path') do
      package.stubs(:output_path => 'qux')
      expect(package.handler_path).to eq '/qux'
    end
    it('builder handler with full output path') do
      package.expects(:full_output_path).once
      package.handler
    end
  end

  context('development mode') do
    let(:dev_package) { Pannier::Package::Development.new(package) }
    it('delegates assets to input assets') do
      dev_package.expects(:input_assets).once
      dev_package.assets
    end
    it('delegates path to input path') do
      dev_package.expects(:input_path).once
      dev_package.path
    end
    it('delegates full_path to full input path') do
      dev_package.expects(:full_input_path).once
      dev_package.full_path
    end
    it('builds handler path from input path') do
      dev_package.stubs(:input_path => 'quux')
      expect(dev_package.handler_path).to eq '/quux'
    end
    it('builder handler with full input path') do
      dev_package.expects(:full_input_path).once
      dev_package.handler
    end
  end

  describe('#add_input_assets') do
    it('adds assets to input_assets') do
      assets = [
        Pannier::Asset.new(package, '/foo.js'),
        Pannier::Asset.new(package, '/bar.js')
      ]
      package.add_input_assets(assets)
      expect(package.input_assets.length).to eq 2
    end
    it('discards assets with same path') do
      assets = [
        Pannier::Asset.new(package, '/foo.js'),
        Pannier::Asset.new(package, '/foo.js')
      ]
      package.add_input_assets(assets)
      expect(package.input_assets.length).to eq 1
    end
  end

  describe('#add_output_assets') do
    it('adds assets to output_assets') do
      assets = [
        Pannier::Asset.new(package, '/foo.js'),
        Pannier::Asset.new(package, '/bar.js')
      ]
      package.add_output_assets(assets)
      expect(package.output_assets.length).to eq 2
    end
    it('discards assets with same path') do
      assets = [
        Pannier::Asset.new(package, '/bar.js'),
        Pannier::Asset.new(package, '/bar.js')
      ]
      package.add_output_assets(assets)
      expect(package.output_assets.length).to eq 1
    end
  end

  describe('#build_assets_from_paths') do
    it('constructs assets before adding') do
      Pannier::Asset.expects(:new).with(package, '/foo/bar.js').once
      package.build_assets_from_paths(['/foo/bar.js'])
    end
  end

  describe('#add_modifiers') do
    it('adds processor instructions to modify assets') do
      modifier_1, modifier_2 = proc {}, proc {}
      package.add_modifiers([modifier_1, modifier_2])
      expect(package.processors).to eq [
        [:modify!, modifier_1],
        [:modify!, modifier_2]
      ]
    end
  end

  describe('#add_concatenator') do
    it('adds processor instruction to concat with given basename') do
      package.add_concatenator('main.css')
      expect(package.processors.first.take(2)).to eq [:concat!, 'main.css']
    end
    it('add processor instructions concat assets with default concatenator') do
      package.add_concatenator('main.css')
      expect(package.processors.first.last).to be_a Pannier::Concatenator
    end
    it('add processor instructions concat assets with user concatenator') do
      concatenator = proc {}
      package.add_concatenator('main.css', concatenator)
      expect(package.processors.first.last).to be concatenator
    end
  end

  describe('#add_middleware') do
    it('adds middleware proc') do
      mw_klass = mock('Class:Middleware')
      package.add_middleware(mw_klass)
      expect(package.middlewares.first).to be_a Proc
    end
    it('constructs using given args when proc is called') do
      mw_klass = mock('Class:Middleware')
      mw_klass.expects(:new).with(app, 1, 2)
      package.add_middleware(mw_klass, 1, 2) {}
      package.middlewares.first.call(app)
    end
  end

  describe('#owns_any?') do
    before do
      asset = Pannier::Asset.new(package, '/foo/bar/baz.js')
      package.add_input_assets([asset])
    end
    it('returns true if package has asset which matches given input paths') do
      expect(package.owns_any?('/foo/bar/baz.js')).to be_true
    end
    it('returns false if has no assets which match given input paths') do
      expect(package.owns_any?('/qux/quux.js', '/bibimbap.js')).to be_false
    end
  end

  describe('processing') do
    let(:asset) { Pannier::Asset.new(package, '/foo.css') }
    before(:each) do
      app.stubs(:output_path => '/foo/bar/output')
      package.add_input_assets([asset])
    end

    describe('#process!') do
      it('copies and writes files when processors have not been added') do
        default_sequence = sequence('default sequence')
        package.expects(:copy!).in_sequence(default_sequence)
        package.expects(:write_files!).in_sequence(default_sequence)
        package.process!
      end
      it('sends processor methods to self when processors are added') do
        package.add_modifiers([proc {}, proc {}])
        processor_sequence = sequence('processor sequence')
        package.expects(:copy!).in_sequence(processor_sequence)
        package.expects(:modify!).in_sequence(processor_sequence).twice
        package.expects(:write_files!).in_sequence(processor_sequence)
        package.process!
      end
    end 

    describe('#modify!') do
      it('sends #modify with modifier to each output asset') do
        modifier = mock('Modifier')
        package.copy!
        package.output_assets.each { |a| a.expects(:modify!).with(modifier) }
        package.modify!(modifier)
      end
    end
    
    describe('#concat!') do
      let(:concatenator) { proc {} }
      before(:each) do
        package.add_input_assets([Pannier::Asset.new(package, '/bar.css')])
        package.copy!
      end
      it('replaces all output assets with a single asset') do
        package.concat!('main.css', concatenator)
        expect(package.output_assets.length).to be 1
      end
      it('calls concatenator') do
        contents = package.output_assets.map(&:content)
        concatenator.expects(:call).with(contents).once
        package.concat!('main.css', concatenator)
      end
      it('names output asset') do
        package.concat!('main.css', concatenator)
        expect(package.output_assets.first.basename).to eq 'main.css'
      end
    end
    
    describe('#copy!') do
      it('copies input_assets to output_assets') do
        package.copy!
        expect(package.output_assets).to eq package.input_assets
      end
    end
    
    describe('#write_files!') do
      it('sends #write_file! with full_output_path to each output asset') do
        package.copy!
        package.output_assets.each do |asset|
          asset.expects(:write_file!).with(package.full_output_path).once
        end
        package.write_files!
      end
      it('sends #write_file! with other path if given to each output asset') do
        package.copy!
        package.output_assets.each do |asset|
          asset.expects(:write_file!).with('/qux').once
        end
        package.write_files!('/qux')
      end
    end
  end

end
