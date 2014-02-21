class BresenhamRasterization
  def initialize(from_x, from_y, to_x, to_y)
    @from_x, @from_y = from_x, from_y
    @to_x, @to_y     = to_x, to_y
  end

  def rasterize_on_canvas(canvas)
    initialize_from_and_to_coordinates
    rotate_coordinates_by_ninety_degrees if steep_slope?
    swap_from_and_to if @drawing_from_x > @drawing_to_x
    draw_line_pixels_on canvas
  end

  def steep_slope?
    (@to_y - @from_y).abs > (@to_x - @from_x).abs
  end

  def initialize_from_and_to_coordinates
    @drawing_from_x, @drawing_from_y = @from_x, @from_y
    @drawing_to_x, @drawing_to_y     = @to_x, @to_y
  end

  def rotate_coordinates_by_ninety_degrees
    @drawing_from_x, @drawing_from_y = @drawing_from_y, @drawing_from_x
    @drawing_to_x, @drawing_to_y     = @drawing_to_y, @drawing_to_x
  end

  def swap_from_and_to
    @drawing_from_x, @drawing_to_x = @drawing_to_x, @drawing_from_x
    @drawing_from_y, @drawing_to_y = @drawing_to_y, @drawing_from_y
  end

  def error_delta
    delta_x = @drawing_to_x - @drawing_from_x
    delta_y = (@drawing_to_y - @drawing_from_y).abs
    delta_y.to_f / delta_x
  end

  def vertical_drawing_direction
    @drawing_from_y < @drawing_to_y ? 1 : -1
  end

  def draw_line_pixels_on(canvas)
    @error = 0.0
    @y     = @drawing_from_y
    @drawing_from_x.upto(@drawing_to_x).each do |x|
     set_pixel_on canvas, x, @y
      calculate_next_y_approximation
    end
  end

  def calculate_next_y_approximation
    @error += error_delta
    if @error >= 0.5
      @error -= 1.0
      @y += vertical_drawing_direction
    end
  end

  def set_pixel_on(canvas, x, y)
    if steep_slope?
      canvas.set_pixel y, x
    else
      canvas.set_pixel x, y
    end
  end
end
