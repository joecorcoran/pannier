module Pannier
  class FileHandler < Rack::File

    def initialize(allowed, *args)
      @allowed = allowed
      super(*args)
    end

    def call(env)
      return fail(404, 'File not a member of this package') unless handle?(env)
      super(env)
    end

    def handle?(env)
      path = Rack::Utils.unescape(env['PATH_INFO'])
      @allowed.include?(File.join(@root, path))
    end

  end
end
