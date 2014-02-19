require_relative "spec_helper.rb"

describe GameLogic do
  before :all do
    @game = GameLogic.new word: "Varna", category: "City"
  end
  
  describe "#new" do
    it "should return an instance from GameLogic" do
      @game.should be_an_instance_of GameLogic
    end
  end
  
  describe "#make_pattern_for_word" do
    it "should make pattern for initialized word with " do
      @game.pattern.should eq "_____"
    end
  end
end