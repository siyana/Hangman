module Shapes
  class Point
    attr_reader :x, :y
    
    def initialize(x,y)
      @x = x
      @y = y
    end
        
    def rasterize_on_canvas(canvas)
      canvas.set_pixel x,y
    end
  end
    
  class Line
    require_relative "brezenham_rasterization"
    attr_reader :from, :to
        
    def initialize(from,to)
      if from.x > to.x or (from.x == to.x and from.y > to.y)
        @from = to
        @to = from
      else
        @from = from
        @to = to
      end
    end
        
    def rasterize_on_canvas(canvas)
      BresenhamRasterization.new(from.x, from.y, to.x, to.y).rasterize_on_canvas canvas
    end
  end
    
  class Rectangle
    attr_reader :left, :right
        
    def initialize(left, right)
      if left.x > right.x or (left.x == right.x and left.y > right.y)
        @left  = right
        @right = left
      else
        @left  = left
        @right = right
      end
    end
        
    def rasterize_on_canvas(canvas)
      [
        Line.new(top_left, top_right),
        Line.new(top_right, bottom_right),
        Line.new(bottom_right, bottom_left),
        Line.new(bottom_left, top_left),
      ].each { |line| line.rasterize_on_canvas canvas }
    end
        
    def top_left
      Point.new left.x, [left.y, right.y].min
    end
        
    def top_right
      Point.new right.x, [left.y, right.y].min
    end
        
    def bottom_left
      Point.new left.x, [left.y, right.y].max
    end
        
    def bottom_right
      Point.new right.x, [left.y, right.y].max
    end
  end
end
