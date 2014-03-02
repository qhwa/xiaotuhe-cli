require 'zip'
require 'fileutils'

module Xth

  class Blob

    class Base

      attr_accessor :file, :name

      def initialize( file, name=nil )
        @file = file
        @name = name || ::File.basename( file )
      end

      def to_io
        file
      end
    end
    
    class Image < Base
    end

    class File < Base
      def to_io
        ::File.open( file )
      end
    end

    class Directory < Base

      def initialize( path )
        super( path, "#{path}/" )
      end

      def to_io
        tmpfile = Tempfile.new( ["tmp",".zip"] )
        path    = tmpfile.path
        root    = self.file

        # 删除文件，否则创建 zip 的时候会失败
        tmpfile.unlink

        Zip::File.open( path, Zip::File::CREATE ) do |zipfile|
          Dir.glob( ::File.join( root, '**', '**') ) do |file|
            zipfile.add file.sub( root, '').sub( /^\//, '' ), file
          end
        end

        ::File.open path
      end

    end

    class Text < Base

      def initialize( text )
        super StringIO.new(text), "text"
      end
    end

  end
end
