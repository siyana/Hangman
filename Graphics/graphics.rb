module Graphics
  require_relative "shapes"
  
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
  
  private
  
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
        "o"
      end
      
      def draw_blank_pixel
        " "
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