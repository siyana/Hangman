require_relative "spec_helper.rb"

describe GameLogic do
  before :each do
    @game = GameLogic.new word: "Varna", category: "City"
  end
  
  describe "#new" do
    it "should return an instance from GameLogic" do
      @game.should be_an_instance_of GameLogic
    end
  end
  
  describe "#make_pattern_for_word" do
    it "should make pattern for initialized word with" do
      wanted_pattern = @game.choosen_word.tr("a-z", "*")
      @game.pattern.should eq wanted_pattern
    end
  end
  
  describe "#play" do
    it "should pass when a letter is guessed" do
      @game.play('a').should eq :guessed_letter
    end
    
    it "should pass when a letter is not in the word" do
      @game.play('w').should eq :incorrect_letter
    end
    
    it "should increase bad guessed when a letter is not in the word" do
      @game.play('w')
      @game.bad_guesses.should eq 1
    end
    
    it "should not increase bad guesses when a letter is in the word" do
      @game.play('a')
      @game.bad_guesses.should eq 0
    end
    
    it "should not accept symbol which is not a letter" do
      @game.play('1').should eq :not_a_letter
    end
    
    it "should catch repeated letters which are in the word" do
      @game.play('a')
      @game.play('a').should eq :repeated_letter
    end
    
    it "should catch repeated letters which are not in the word" do
      @game.play('w')
      @game.play('w').should eq :repeated_letter
    end
    
    it "should stop game when the word is guessed in less than 10 tries" do
      @game.play('v')
      @game.play('a')
      @game.play('r')
      @game.play('n').should eq :win
    end
    
    it "should stop game when the word is not guessed in less than 10 tries" do
      @game.play('w')
      @game.play('q')
      @game.play('e')
      @game.play('d')
      @game.play('t')
      @game.play('p')
      @game.play('z')
      @game.play('m')
      @game.play('h')
      @game.play('l').should eq :loss
    end
    
    it "should stop game if the written word is choosen word" do
      @game.play('varna').should eq :win
    end
    
    it "should stop game if the written word is choosen word and there is guessed letters" do
      @game.play('a')
      @game.play('varna').should eq :win
    end
    
    it "should stop game if the written word is choosen word and there is not guessed letters" do
        @game.play('w')
        @game.play('varna').should eq :win
    end
  end  
end