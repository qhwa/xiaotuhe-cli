require 'httmultiparty'

module Xth

  class Pusher

    include HTTMultiParty

    base_uri 'http://xiaotuhe.com'

    attr_accessor :options

    def self.push_clipboard( &block )
      new( nil, clipboard: true, unzip: true ).push &block
    end

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

    def push( &block )
      begin
        self.class.post( '/shares', body: {
          options:  @opt,
          file:     @file,
          name:     filename,
          format:   :json
        }).tap do |response|
          if block_given?
            if response && response['success']
              block.call response['url']
            else
              block.call false
            end
          end
        end
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
