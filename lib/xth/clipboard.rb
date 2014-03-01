require 'tempfile'
require 'stringio'
require 'gtk2'

module Xth

  class Clipboard

    class << self

      def to_io
        to_blob.to_io
      end

      def to_blob
        @board ||= ::Gtk::Clipboard.get( Gdk::Selection::CLIPBOARD )
        to_image || to_file || to_string
      end

      def to_image
        img = @board.wait_for_image
        if img
          file = Tempfile.new(["clipboard", ".png"]).tap do |f|
            img.save( f.path, "png" )
          end

          Blob::Image.new file, "image from clipboard"
        end
      end

      def to_file
        path = @board.wait_for_text
        if path && File.readable?( path )
          if File.directory?( path )
            Blob::Directory.new path
          else
            Blob::File.new path
          end
        end
      end

      def to_string
        Blob::String.new @board.wait_for_text
      end

    end

  end

end
