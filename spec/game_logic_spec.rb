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
    if "should make pattern for initialized word with '_'"
        #pattern = @game.make_pattern_for_word "Varna"
        
        @game = GameLogic.new word: "Varna", category: "City"
        pattern = make_pattern_for_word "Varna"
        pattern.should eq "_____"
    end
  end
end