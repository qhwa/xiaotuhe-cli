# Xth command-line runner
module Xth

  class Cli

    class << self

      def push( file, options={} )
        Pusher.new( file, options ).push
      end

      def push_clipboard( file )
      end

    end

  end

end
