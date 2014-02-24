require 'httmultiparty'

module Xth

  class Pusher

    include HTTMultiParty

    base_uri 'http://localhost:3000'

    def initialize( file )
      @file = file
    end

    def push
      begin
        self.class.post( '/files', query: {
          file: @file
        })
      rescue => e
        e.message
      end
    end

  end

end
