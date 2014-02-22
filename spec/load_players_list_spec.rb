require_relative "spec_helper.rb"
require "json"

describe LoadPlayers do
  let(:json_records) { JSON.parse(IO.read "./Model/players_info.json") }
  describe "#load_all_players" do
    it "should load words for dictionary from json" do
      LoadPlayers.load_all_players.should eq json_records
    end
  end
  
  describe "#add_player" do
    it "should add new player to json file" do
      added_player = {"player_name" => "Test Player".capitalize, "player_score" => 0}
      LoadPlayers.add_player added_player
      LoadPlayers.load_all_players.any? { |player| player['player_name'] == added_player['player_name']}.should be_true
    end
    it "should not duplicated players in json file" do
      added_player = {"player_name" => "Test Player".capitalize, "player_score" => 0}
      LoadPlayers.add_player added_player
      added_player = {"player_name" => "Test Player".capitalize, "player_score" => 0}
      LoadPlayers.load_all_players.select { |player| player['player_name'] == added_player['player_name']}.length.should eq 1
    end
    it "should not add player whose name is not valid" do
      added_player = {"player_name" => "1".capitalize, "player_score" => 0}
      LoadPlayers.add_player added_player
      LoadPlayers.load_all_players.none? { |player| player['player_name'] == added_player['player_name']}.should be_true
    end
    it "should not add player with blank name" do
      added_player = {"player_name" => " ".capitalize, "player_score" => 0}
      LoadPlayers.add_player added_player
      LoadPlayers.load_all_players.none? { |player| player['player_name'] == added_player['player_name']}.should be_true
    end

    it "should not add spaces after and before player name" do
      added_player = {"player_name" => "  Name  ", "player_score" => 0}
      LoadPlayers.add_player added_player
      LoadPlayers.load_all_players.none? { |player| player['player_name'] == "  Name  "}.should be_true
      LoadPlayers.load_all_players.select { |player| player['player_name'] == "Name"}.length.should eq 1
    end
  end
  
  describe "#update_player_score" do
    it "should update player score by 1" do
      previous_score = LoadPlayers.load_all_players[0]["player_score"]
      LoadPlayers.update_player_score(0)
      new_score = LoadPlayers.load_all_players[0]["player_score"]
      new_score.should eq (previous_score + 1)
    end

    it "should not update score for guest and not valid player" do
      LoadPlayers.update_player_score(-1).should eq :not_valid_index
      LoadPlayers.update_player_score(nil).should eq :guest
    end
  end
  
  describe "#get_player_score" do
    it "should return current player's score" do
      LoadPlayers.get_player_score(0).should eq LoadPlayers.load_all_players[0]["player_score"]
    end
  end
  
  describe "#get_player_name" do
    it "should return choosen player's name" do
      LoadPlayers.get_player_name(0).should eq LoadPlayers.load_all_players[0]["player_name"]
    end
  end

   describe "#delete_player" do
    it "should delete player from json file" do
      deleted_player = LoadPlayers.load_all_players.last
      LoadPlayers.delete_player deleted_player
      LoadPlayers.load_all_players.none? { |player| player['player_name'] == deleted_player['player_name']}.should be_true
    end
  end
  
 
end