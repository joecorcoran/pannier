require 'spec_helper'

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
  describe('#add_assets') do
    it('turns paths into asset objects') do
      package.add_assets('foo.js')
      expect(package.input_assets.first).to be_a Pannier::Asset
    end
    it('constructs assets with basename, dirname and self') do
      Pannier::Asset.expects(:new).with('bar.js', 'foo', package)
      package.add_assets('foo/bar.js')
    end
    it('only stores unique assets') do
      package.add_assets('foo.js', 'bar.js', 'foo.js')
      expect(package.input_assets.length).to eq 2
    end
  end
  describe('#add_modifiers') do
    it('adds processor instructions to modify assets') do
      modifier_1, modifier_2 = proc {}, proc {}
      package.add_modifiers(modifier_1, modifier_2)
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

end
