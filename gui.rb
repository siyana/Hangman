module GUI
  require "green_shoes"
  require "./Model/load_dictionary"
  require "./Model/load_players_list"

  MENU_AGANST_PC = "Against PC"
  MENU_MULTYPLAYER = "Multiplayer"
  MENU_OPTIONS = "Options"
  MENU_SCORES = "Scores"



  OPTIONS_ADD_WORD = "Add word"
  OPTIONS_DELETE_WORD = "Delete word"
  OPTION_ADD_PLAYER = "Add player"
  OPTION_DELETE_PLAYER = "Delete player"

  @option_menu_options = [OPTIONS_ADD_WORD, OPTIONS_DELETE_WORD, OPTION_ADD_PLAYER, OPTION_DELETE_PLAYER]

  Shoes.app  title: "Main menu", #set window size
   width: 200, height: 200 do
    @main_menu_options = [MENU_AGANST_PC, MENU_MULTYPLAYER, MENU_OPTIONS, MENU_SCORES]
    @main_menu_buttons = stack do
                           @main_menu_options.map do |option|
                             button "#{option}"
                           end
                         end
    @main_menu_buttons[0].click {choose_dictionary}
  end
  def choose_dictionary
  end
   Shoes.app do #shoes main menu options

  end
end