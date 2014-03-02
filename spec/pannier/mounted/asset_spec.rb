require 'spec_helper'
require 'pannier/mounted/asset'

describe Pannier::Asset do
  let(:package) { stub('Package') }
  let(:asset)   { Pannier::Asset.new('foo.css', 'bar', package) }

  describe('#serve_from') do
    it('returns path relative to given root') do
      app = stub('App', :root => '/assets', :output_path => 'bar')
      expect(asset.serve_from(app)).to eq '/assets/foo.css'
    end
  end

end
