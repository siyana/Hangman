class Drawer
  require_relative "graphics"

  CANVAS_WIDTH = 30
  CANVAS_HEIGHT = 13

  def initialize(width,height)
      @width = width
      @height = height
      @canvas = Graphics::Canvas.new @width, @height
  end

  def draw_bottom_gibbet_line
    @canvas.draw Shapes::Line.new(Shapes::Point.new(@width - 7, CANVAS_HEIGHT - 1), Shapes::Point.new(CANVAS_WIDTH - 1, CANVAS_HEIGHT - 1))
  end

  def draw_vertical_gibbet_line
    @canvas.draw Shapes::Line.new(Shapes::Point.new(@width - 4, 0), Shapes::Point.new(@width - 4, CANVAS_HEIGHT - 1))
  end

  def draw_top_gibbet_line
    @canvas.draw Shapes::Line.new(Shapes::Point.new(4, 0), Shapes::Point.new(@width - 4, 0))
  end

  def draw_small_vertical_gibbet_line
    @canvas.draw Shapes::Line.new(Shapes::Point.new(4, 0), Shapes::Point.new(4, 1))
  end

  def draw_hangman_head
    @canvas.draw Shapes::Rectangle.new(Shapes::Point.new(2, 1), Shapes::Point.new(6, 3))
  end

  def draw_hangman_body
    @canvas.draw Shapes::Line.new(Shapes::Point.new(4, 3), Shapes::Point.new(4, 9))
  end

  def draw_hangman_right_arm
    @canvas.draw Shapes::Line.new(Shapes::Point.new(4, 4), Shapes::Point.new(7, 7))
  end

  def draw_hangman_left_arm
    @canvas.draw Shapes::Line.new(Shapes::Point.new(4, 4), Shapes::Point.new(1, 7))
  end

  def draw_hangman_right_foot
    @canvas.draw Shapes::Line.new(Shapes::Point.new(4, 9), Shapes::Point.new(7, 12))
  end

  def draw_hangman_left_foot
    @canvas.draw Shapes::Line.new(Shapes::Point.new(4, 9), Shapes::Point.new(1, 12))
  end

  def render_canvas#_as(renderer)
    @canvas.render_as(Graphics::Renderers::Ascii)
  end
end

#drawer = Drawer.new
#drawer.draw_bottom_gibbet_line
#puts drawer.render_canvas