module Graphics
  require "./shapes"
  
  class Canvas
    attr_reader :width, :height
    def initialize(width, height)
      @width = width
      @height = height
      @canvas = Array.new(height) { Array.new(width)}
    end
      
    def set_pixel(x,y)
      @canvas[y][x] = 1
    end
      
    def pixel_at?(x,y)
      @canvas[y][x]
    end
      
    def draw(shape)
      shape.rasterize_on_canvas self
    end
      
    def render_as(renderer)
      renderer.new(@canvas).render
    end
  end
  
  class Renderers
    class BaseRenderer
      attr_reader :canvas
      
      def initialize(canvas)
        @canvas = canvas
      end
      
      def render
        raise NoImplementedError
      end
      
    end
    
    class Ascii < BaseRenderer
      def render
        rendered_pixels = @canvas.map do |line|
            line.map { |pixel| set_pixel pixel}
        end
        join_lines rendered_pixels.map { |line| join_pixels_in_line line}
      end
    
      private
      def set_pixel(pixel)
        pixel.nil? ? draw_blank_pixel : draw_full_pixel
      end
      
      def draw_full_pixel
        "@"
      end
      
      def draw_blank_pixel
        "-"
      end
      
      def join_pixels_in_line(line)
        line.join("")
      end
      
      def join_lines(lines)
        lines.join("\n")
      end
    end
  end
end
  

module Graphics
    canvas = Canvas.new 30, 30
    
    # Door frame and window
    canvas.draw Shapes::Rectangle.new(Shapes::Point.new(3, 3), Shapes::Point.new(18, 12))
    canvas.draw Shapes::Rectangle.new(Shapes::Point.new(1, 1), Shapes::Point.new(20, 28))
    
    # Door knob
    canvas.draw Shapes::Line.new(Shapes::Point.new(4, 15), Shapes::Point.new(7, 15))
    canvas.draw Shapes::Point.new(4, 16)
    
    # Big "R"
    canvas.draw Shapes::Line.new(Shapes::Point.new(8, 5), Shapes::Point.new(8, 10))
    canvas.draw Shapes::Line.new(Shapes::Point.new(9, 5), Shapes::Point.new(12, 5))
    canvas.draw Shapes::Line.new(Shapes::Point.new(9, 7), Shapes::Point.new(12, 7))
    canvas.draw Shapes::Point.new(13, 6)
    canvas.draw Shapes::Line.new(Shapes::Point.new(12, 8), Shapes::Point.new(13, 10))
    
    puts canvas.render_as(Renderers::Ascii)
end