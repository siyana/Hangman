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
    
    def ==(other)
      x == other.x and y == other.y
    end
  
    alias_method :eql?, :==
  
    def hash
      [x,y].hash
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
    
    def ==(other)
      from == other.from and to == other.to
    end
    
    alias_method :eql?, :==
    
    def hash
      [from.hash, to.hash].hash
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
    
    def ==(other)
      top_left == other.top_left and bottom_right == other.bottom_right
    end
    
    alias_method :eql?, :==
    
    def hash
      [top_left, bottom_right].hash
    end
  end
end
