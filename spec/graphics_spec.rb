require "spec_helper.rb"

describe Graphics do

    describe Graphics::Canvas do
        
    before :each do
      @canvas = Graphics::Canvas.new 10,5
    end
    
    describe "#new" do
      it "should return instance of canvas" do
        @canvas.should be_instance_of Graphics::Canvas
      end
      
      it "should return proper width" do
        @canvas.width.should eq 10
      end
      
      it "should return proper height" do
        @canvas.height.should eq 5
      end
    end
    
    describe "#set_pixel" do
      it "should get false for unset pixel" do
        @canvas.pixel_at?(0,1).should be_false
      end
      
      it "should set correct pixel" do
        @canvas.set_pixel 0,1
        @canvas.pixel_at?(0,1).should be_true
      end
    end
    
    describe "#render_as" do
      it "should render blank canvas" do
        check_rendering "          \n          \n          \n          \n          "
      end
        
      it "should render blank canvas" do
        @canvas.set_pixel 0,0
        @canvas.set_pixel 0,1
        check_rendering "o         \no         \n          \n          \n          "
      end
    end
    
    describe "#draw" do
      it "should draw a single point" do
        @canvas.draw Shapes::Point.new 0,1
        @canvas.pixel_at?(0,1).should be_true
      end
      
      it "should draw a single horizontal line" do
        @canvas.draw Shapes::Line.new(Shapes::Point.new(0, 1), Shapes::Point.new(5, 1))
        check_rendering "          \noooooo    \n          \n          \n          "
      end
      
      it "should draw a single vertical line" do
        @canvas.draw Shapes::Line.new(Shapes::Point.new(0, 0), Shapes::Point.new(0, 3))
        check_rendering "o         \no         \no         \no         \n          "
      end
      
      it "should draw a single vertical line" do
        @canvas.draw Shapes::Line.new(Shapes::Point.new(0, 0), Shapes::Point.new(0, 3))
        check_rendering "o         \no         \no         \no         \n          "
      end
      
      it "should draw lines with a small slope" do
        @canvas.draw Shapes::Line.new(Shapes::Point.new(1, 1), Shapes::Point.new(8, 3))
        check_rendering "          \n oo       \n   oooo   \n       oo \n          "
      end
      
      it "should draw lines with signifficant scope" do
        @canvas.draw Shapes::Line.new(Shapes::Point.new(1, 1), Shapes::Point.new(3, 4))
        check_rendering "          \n o        \n  o       \n  o       \n   o      "
      end
      
      it "should draw lines with switched ends" do
        @canvas.draw Shapes::Line.new(Shapes::Point.new(3, 4), Shapes::Point.new(1, 1))
        check_rendering "          \n o        \n  o       \n  o       \n   o      "
      end
      
      it "should draw lines with equal ends as point" do
        @canvas.draw Shapes::Line.new(Shapes::Point.new(0, 0), Shapes::Point.new(0, 0))
        check_rendering "o         \n          \n          \n          \n          "
      end
      
      it "should draw a simple rectangle" do
        @canvas.draw Shapes::Rectangle.new(Shapes::Point.new(1, 1), Shapes::Point.new(8, 3))
        check_rendering "          \n oooooooo \n o      o \n oooooooo \n          "
      end
      
      it "should draw rectangle with zero width and height as a point" do
        @canvas.draw Shapes::Rectangle.new(Shapes::Point.new(0, 0), Shapes::Point.new(0, 0))
        check_rendering "o         \n          \n          \n          \n          "
      end
      
      it "should draw multiple points" do
        @canvas.draw Shapes::Point.new 0,0
        @canvas.draw Shapes::Point.new 0,1
        check_rendering "o         \no         \n          \n          \n          "
      end
      
      it "should draw multiple lines" do
        @canvas.draw Shapes::Line.new(Shapes::Point.new(0, 0), Shapes::Point.new(0, 3))
        @canvas.draw Shapes::Line.new(Shapes::Point.new(1, 1), Shapes::Point.new(8, 3))
        check_rendering "o         \nooo       \no  oooo   \no      oo \n          "
      end
      
      it "should draw multiple rectangles" do
        @canvas.draw Shapes::Rectangle.new(Shapes::Point.new(0, 0), Shapes::Point.new(1, 1))
        @canvas.draw Shapes::Rectangle.new(Shapes::Point.new(1, 1), Shapes::Point.new(8, 3))
        check_rendering "oo        \nooooooooo \n o      o \n oooooooo \n          "
      end
      
      it "should draw multiple shapes" do
        @canvas.draw Shapes::Rectangle.new(Shapes::Point.new(0, 0), Shapes::Point.new(1, 1))
        @canvas.draw Shapes::Line.new(Shapes::Point.new(0, 0), Shapes::Point.new(0, 3))
        @canvas.draw Shapes::Point.new 2,2
        check_rendering "oo        \noo        \no o       \no         \n          "
      end
    end
    
    describe Shapes do
        
      describe Shapes::Point do
        before :each do
          @point = Shapes::Point.new 1,2
        end
      
        describe "#new" do
          it "should be instance of Point" do
            @point.should be_instance_of Shapes::Point
          end
        
          it "should return correct x coordinate of point" do
            @point.x.should eq 1
          end
        
          it "should return correct y coordinate of point" do
            @point.y.should eq 2
          end
        end
      end
    
      describe Shapes::Line do
        before :each do
          @line = Shapes::Line.new(Shapes::Point.new(0, 0), Shapes::Point.new(0, 3))
        end
        
        it "should be instance of Line" do
          @line.should be_instance_of Shapes::Line
        end
        
        #add hash to shapes and eql
        it "should return correct from point" do
          @line.from.should eq Shapes::Point.new(0,0)
        end
        
        it "should return correct from point with swapped ends" do
          swapped_line = Shapes::Line.new(Shapes::Point.new(0, 3), Shapes::Point.new(0, 0))
          swapped_line.from.should eq Shapes::Point.new(0,0)
        end
        
        it "should return correct to point" do
         @line.to.should eq Shapes::Point.new(0,3)
        end
        
        it "should return correct to point with swapped ends" do
          swapped_line = Shapes::Line.new(Shapes::Point.new(0, 3), Shapes::Point.new(0, 0))
          swapped_line.to.should eq Shapes::Point.new(0,3)
        end
      end
      
      describe Shapes::Rectangle do
        before :each do
          @rectangle = Shapes::Rectangle.new(Shapes::Point.new(0, 0), Shapes::Point.new(1, 1))
        end
        
        it "should be instance of Line" do
          @rectangle.should be_instance_of Shapes::Rectangle
        end
      end
   end
    
  end
    
    #help methods
  def check_rendering(expected)
    ascii = @canvas.render_as(Graphics::Renderers::Ascii)
    ascii.should eq expected
  end
end