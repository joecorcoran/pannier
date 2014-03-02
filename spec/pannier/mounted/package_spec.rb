require 'spec_helper'
require 'pannier/asset'
require 'pannier/mounted/package'

describe Pannier::Package do
  let(:app) { mock('App') }
  let(:package) { Pannier::Package.new(:foo, app) }

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

  it('builds handler path from output path') do
    package.stubs(:output_path => 'qux')
    expect(package.handler_path).to eq '/qux'
  end
  it('builder handler with full output path') do
    package.expects(:full_output_path).once
    package.handler
  end

end
