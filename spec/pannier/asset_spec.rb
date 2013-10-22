require 'spec_helper'
require 'pannier/asset'

describe Pannier::Asset do
  let(:package) { mock('Package') }
  let(:asset)   { Pannier::Asset.new(package, '/home/bar/foo.css') }

  describe('#content') do
    it('returns nil if file does not exist when asset is instantiated') do
      expect(asset.content).to be_nil
    end
    it('returns file content if file exists when asset is instantiated') do
      File.stubs(:exists?).returns(true)
      File.stubs(:read).returns('/**/')
      expect(Pannier::Asset.new(package, '/home/qux.js').content).to eq '/**/'
    end
  end

  describe('#eql?') do
    it('returns true when input_path is the same') do
      other = stub(:input_path => '/home/bar/foo.css')
      expect(asset.eql?(other)).to be_true
    end
    it('returns false when input_path is different') do
      other = stub(:input_path => 'xyz')
      expect(asset.eql?(other)).to be_false
    end
  end
  
  describe('#hash') do
    it('delegates to input_path') do
      expect(asset.hash).to eq asset.input_path.hash
    end
  end
  
  describe('#<=>') do
    specify do
      expect { asset > stub(:input_path => '/a/foo.css') }.to be_true
      expect { asset < stub(:input_path => '/z/foo.css') }.to be_true
    end
  end

  describe('#modify!') do
    it('mutates content') do
      modifier = proc { |content, _| [content.reverse, _] }
      asset.content = 'abc'
      asset.modify!(modifier)
      expect(asset.content).to eq 'cba'
    end
    it('mutates basename') do
      modifier = proc { |_, basename| [_, 'baz-'+basename] }
      asset.modify!(modifier)
      expect(asset.basename).to eq 'baz-foo.css'
    end
  end
end
