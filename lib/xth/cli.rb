# Xth command-line runner
module Xth

  class Cli

    class << self

      def push( file )
        Pusher.new( file ).push
      end

      def push_clipboard( file )
      end

    end

  end

end
