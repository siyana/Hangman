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
      added_player = {"player_name" => "Test Player".capitalize, "player_score" => "0"}
      LoadPlayers.add_player added_player
      json_records.any? { |player| player['player_name'] == added_player['player_name']}.should be_true
    end
    it "should not duplicated players in json file" do
        added_player = {"player_name" => "Test Player".capitalize, "player_score" => "0"}
        LoadPlayers.add_player added_player
         added_player = {"player_name" => "Test Player".capitalize, "player_score" => "0"}
        json_records.select { |player| player['player_name'] == added_player['player_name']}.length.should eq 1
    end
  end
  
  describe "#update_player_score" do
    it "should update player score by 1" do
      player = json_records[0]
      previous_score = player["player_score"]
      LoadPlayersgit.update_player_score(0)
      new_score = json_records[0]["player_score"]
      new_score.should eq (previous_score + 1)
      
    end
  end
  
  describe "#delete_player" do
    it "should delete player from json file" do
      deleted_player = {"player_name" => "Test Player".capitalize, "player_score" => "0"}
      LoadPlayers.delete_player deleted_player
      json_records.none? { |player| player['player_name'] == deleted_player['player_name']}.should be_true
    end
  end
  
 
end