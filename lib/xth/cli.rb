# Xth command-line runner
module Xth

  class Cli

    class << self

      def push( file, options={} )
        Pusher.new( file, options ).push
      end

    end

  end

end
