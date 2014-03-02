require 'green_shoes'

module Xth

  class GUI

    class App

      def start

        Gtk::StatusIcon.new.tap do |si|
          si.stock = Gtk::Stock::DIALOG_INFO
          si.signal_connect('activate') do |icon|
            icon.blinking = !icon.blinking
          end
        end

        Shoes.app width: 376 do
          @stack = stack {}
          ::Xth::GUI.new( self, @stack ).render
        end
      end

    end

    def initialize( app, stack )
      @app, @stack = app, stack
    end

    def render
      Clipboard.to_blob.tap do |blob|
        block = case blob
                when ::Xth::Blob::Image
                  render_image blob
                when ::Xth::Blob::File
                  render_file blob
                when ::Xth::Blob::Directory
                  render_dir blob
                else
                  render_empty blob
                end
        @stack.app &block
      end
    end

    def render_image blob
      lambda do |app|
        img       = blob.to_io.path
        max_img_w = 300

        stack width: 360, align: 'center', margin: 8 do
          w, h = imagesize(img)
          if w > max_img_w
            h = max_img_w / w.to_f * h
            w = max_img_w
          end
          image img, width: w, height: h
        end

        action_stack = stack do
          button "Share this", margin: 8 do
            ::Xth::Pusher.push_clipboard do |url|
              visit url
            end
          end
        end
      end
    end

    def render_file blob
      lambda do |app|
        stack width: 360, margin: 8 do image 'res/file.png', margin_left: 140, margin_top: 120, margin_bottom: 20
          para blob.to_io, align: 'center', fill: '#DFDFDF'
        end

        stack width: 360 do
          button "Share this", margin_left: 155, margin_top: 20 do
            ::Xth::Pusher.push_clipboard do |url|
              visit url
            end
          end
        end

      end
    end

    def render_dir blob
      lambda do |app|
        stack width: 360, margin: 8 do
          image 'res/folder.png', width: 200, height: 200, margin_left: 80, margin_top: 60, margin_bottom: 20
          para blob.name, align: 'center', fill: '#DFDFDF'
        end

        stack width: 360 do
          button "Share this", margin_left: 155, margin_top: 20 do
            ::Xth::Pusher.push_clipboard do |url|
              visit url
            end
          end
        end
      end
    end

    def render_empty( blob )
      lambda do |app|
        stack width: 360, margin: 8 do
          image 'res/clipboard.png', margin_left: 120, margin_top: 60, margin_bottom: 20
          para "OOPS!", align: 'center', fill: '#DFDFDF'
          para "Your have not copied any image or files,", align: 'center', fill: '#DFDFDF'
          para "please copy some and try again!", align: 'center'
        end
      end
    end
  
  end

end
