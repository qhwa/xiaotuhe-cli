require 'httmultiparty'

module Xth

  class Pusher

    include HTTMultiParty

    base_uri 'http://localhost:3000'

    attr_accessor :options

    def initialize( file, options = {} )
      @opt = options
      @from_clipboard = options[:clipboard]
      if from_clipboard?
        @blob = Clipboard.to_blob
        @file = @blob.to_io
      else
        @file = File.new(file)
      end
    end

    def from_clipboard?
      @from_clipboard
    end

    def push
      begin
        self.class.post( '/shares', body: {
          options:  @opt,
          file:     @file,
          name:     filename
        })
      rescue Errno::ECONNREFUSED
        "connection refused by server"
      end
    end

    def filename
      if @blob
        @blob.name
      else
        File.basename(@file)
      end
    end
  end

end
