module LoadPlayers
  require "json"
  extend self

  PLAYERS_INFO = "./Model/players_info.json"

  def load_all_players
    JSON.parse(IO.read PLAYERS_INFO)
  end

  def add_player(player)
    return :not_valid unless /[[:alpha:]]/.match(player["player_name"])
    player["player_name"] = player["player_name"].strip.capitalize
    all_players =load_all_players
    return :duplicated_name if check_for_player_name player["player_name"], all_players
    all_players << player
    write_to_json all_players
    :succesfully_added
  end

  def delete_player(player)
    all_players = load_all_players
    delete_current_player player, all_players
    write_to_json all_players
  end

  def update_player_score(player_index)
    all_players = load_all_players
    return :guest if all_players.empty?
    player = all_players[player_index]
    player["player_score"] += 1
    all_players[player_index] = player
    write_to_json all_players
  end

  def get_player_score(player_index)
    load_all_players[player_index]['player_score']
  end

  def get_player_name(player_index)
    load_all_players[player_index]['player_name']
  end

  private

  def check_for_player_name(player_name, players)
    players.any? { |player| player["player_name"] == player_name}
  end

  def delete_current_player(player,all_players)
    all_players.delete_if { |current_player| current_player == player}
  end

  def write_to_json(records)
    File.open(PLAYERS_INFO,"w") do |f|
      f.write(JSON.pretty_generate(records))
    end
  end
end