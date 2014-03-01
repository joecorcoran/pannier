require 'spec_helper'
require 'pannier/asset'

describe Pannier::Asset do
  let(:package) { stub('Package') }
  let(:asset)   { Pannier::Asset.new('foo.css', 'bar', package) }

  describe('#path') do
    it('joins dirname and basename') do
      expect(asset.path).to eq 'bar/foo.css'
    end
  end

  describe('#content') do
    it('returns nil if file does not exist when asset is instantiated') do
      expect(asset.content).to be_nil
    end
    it('returns file content if file exists when asset is instantiated') do
      File.stubs(:exists?).returns(true)
      File.stubs(:read).returns('/**/')
      expect(Pannier::Asset.new('qux.js', '.', package).content).to eq '/**/'
    end
  end

  describe('#eql?') do
    it('returns true when paths are the same') do
      other = stub(:path => 'bar/foo.css')
      expect(asset.eql?(other)).to be_true
    end
    it('returns false when paths are different') do
      other = stub(:path => 'xyz')
      expect(asset.eql?(other)).to be_false
    end
  end
  
  describe('#hash') do
    it('delegates to path') do
      expect(asset.hash).to eq asset.path.hash
    end
  end
  
  describe('#<=>') do
    specify do
      expect { asset > stub(:path => 'a/foo.css') }.to be_true
      expect { asset < stub(:path => 'c/foo.css') }.to be_true
    end
  end
  
  describe('#serve_from') do
    it('returns path relative to given root') do
      app = stub('App', :root => '/assets', :output_path => 'bar')
      expect(asset.serve_from(app)).to eq '/assets/foo.css'
    end
  end
  
  describe('#copy_to') do
    it('returns new asset') do
      copied = asset.copy_to('qux')
      expect(copied).not_to be asset
    end
    it('copies dirname') do
      copied = asset.copy_to('qux')
      expect(copied.dirname).to eq 'qux'
    end
    it('copies content when present') do
      asset.content = '/**/'
      copied = asset.copy_to('qux')
      expect(copied.content).to eq '/**/'
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
