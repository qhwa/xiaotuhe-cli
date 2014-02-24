require 'httmultiparty'

module Xth

  class Pusher

    include HTTMultiParty

    base_uri 'http://localhost:3000'

    attr_accessor :options

    def initialize( file, options = {} )
      @file, @opt = File.new(file), options
    end

    def push
      begin
        self.class.post( '/shares', query: {
          options:  @opt,
          file:     @file
        })
      rescue Errno::ECONNREFUSED
        "connection refused by server"
      end
    end

  end

end
