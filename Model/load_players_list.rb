module LoadPlayers
  require "json"
  extend self
  
  PLAYERS_INFO = "./Model/players_info.json"
  
  def load_all_players
    JSON.parse(IO.read PLAYERS_INFO)
  end
  
  def add_player(player)
    all_players =load_all_players
    if check_for_duplicated_player_name player["player_name"], all_players
      return :duplicated_name
    else
      all_players << player
      write_to_json all_players
      return :succesfully_added
    end
  end
  
  def delete_player(player)
    all_players = load_all_players
    all_players.delete_if { |current_player| current_player == player}
    write_to_json all_players
  end
  
  def check_for_duplicated_player_name(player_name, players)
    players.any? { |player| player["player_name"] == player_name}
  end
  
  def write_to_json(records)
    File.open(PLAYERS_INFO,"w") do |f|
      f.write(JSON.pretty_generate(records))
    end
  end
end