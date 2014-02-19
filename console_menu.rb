module ConsoleMenu
  extend self
  require "./Model/load_dictionary"
  require "./Model/load_players_list"
  require "./Graphics/drawer"
  
  def start
    @player_index = choose_player
    show_start_menu
  end
  
  def show_start_menu
    show_options_for_menu @main_menu_options
    get_users_choice_for_main_menu
  end
  
  private
  
  MENU_AGANST_PC = "Against PC"
  MENU_MULTYPLAYER = "Multiplayer"
  MENU_OPTIONS = "Options"
  MENU_SCORES = "Scores"
  
  @main_menu_options = [MENU_AGANST_PC, MENU_MULTYPLAYER, MENU_OPTIONS, MENU_SCORES]
  
  OPTIONS_ADD_WORD = "Add word"
  OPTIONS_DELETE_WORD = "Delete word"
  OPTION_ADD_PLAYER = "Add player"
  OPTION_DELETE_PLAYER = "Delete player"
  
  @option_menu_options = [OPTIONS_ADD_WORD, OPTIONS_DELETE_WORD, OPTION_ADD_PLAYER, OPTION_DELETE_PLAYER]
  
  @draw_hangman_phases = [:draw_bottom_gibbet_line,
                          :draw_vertical_gibbet_line,
                          :draw_top_gibbet_line,
                          :draw_small_vertical_gibbet_line,
                          :draw_hangman_head,
                          :draw_hangman_body,
                          :draw_hangman_right_arm,
                          :draw_hangman_left_arm,
                          :draw_hangman_right_foot,
                          :draw_hangman_left_foot]
  
  #show menus methods
  
  def choose_dictionary
    puts "Do you wanna see categories or word's length? Enter your choice:"
    show_options_for_menu ["By category", "By length"]
    choice = gets.strip.to_i
    case choice
      when 1 then choose_dictionary_by_category
      when 2 then choose_dictionary_by_length
    end
  end
  
  def show_options_menu
    puts "Option menu:"
    show_options_for_menu @option_menu_options
    get_users_choice_for_option_menu
  end
  
  def show_scores
    #sort scores
    all_players = LoadPlayers.load_all_players
    all_players.map { |player| puts "#{player['player_name']}   #{player['player_score']}"}
  end
  
  #choose dictionary methods
  
  def choose_dictionary_by_category
    choice = show_dictionary_options_for LoadDictionary.get_all_categories
    load_words_from_dictionary LoadDictionary.make_dictionary_by_category @all_types[choice - 1]
  end
  
  def choose_dictionary_by_length
    choice = show_dictionary_options_for LoadDictionary.get_all_word_lengths
    load_words_from_dictionary LoadDictionary.make_dictionary_by_word_length @all_types[choice - 1]
  end
  
  def load_words_from_dictionary(dictionary)
    case @initial_choice
      when 1
        game_choice = LoadDictionary.random_word_from_dictionary dictionary
      when 2
        LoadDictionary.show_dictionary dictionary
        puts "Please, enter number of your word"
        game_choice = LoadDictionary.choose_word_from_dictionary dictionary
    end
    @game = GameLogic.new game_choice
    start_game
  end
  
  def start_game
    drawer = Drawer.new
    loop do
      puts "\nYour word's category is: #{@game.category}. Your alphabeth is : #{@game.alphabet.join(", ").upcase}."
      puts "Make a guess: #{@game.pattern}"
      result = @game.play
      case result
        when :loss
          puts "You lose, bro... The word is #{@game.choosen_word.upcase}."
          break
        when :win
          puts "You win! The word is #{@game.choosen_word.upcase}."
          @opponent_index.nil? ? LoadPlayers.update_user_score(@player_index) : LoadPlayers.update_user_score(@opponent_index)
          break
        when :guessed_letter
          puts "Yeah! You rulz :*"
        when :incorrect_letter
          puts "Nope..."
          drawer.public_send @draw_hangman_phases[@game.bad_guesses - 1]
          puts drawer.render_canvas
        when :repeated_letter
          puts "It's not that letter, bro. You've already tried it!"
          #else
        
      end
    end
  end
  
  #help methods
  def show_options_for_menu(menu)
    menu.each_with_index do |option, index|
      puts "#{index + 1}. #{option}"
    end
  end
  
  def show_dictionary_options_for(method)
    puts "Please, choose a dictionary:"
    @all_types = method
    show_options_for_menu @all_types
    gets.strip.to_i
  end
  
  def get_users_choice_for_option_menu
    puts "Please, enter the number of your choice:"
    choice = gets.strip.to_i
    case choice
    when 1
      #add_word_method in LoadDict
      add_word
    when 2
      #delete_word_method in LoadDict
      delete_word
    when 3
      #add_player method in PlayersManager
      add_player
    when 4
      #delete_player method in PlayersManager
      delete_player
    end
  end
  
  def get_users_choice_for_main_menu
    puts "Please, enter the number of your choice:"
    @initial_choice = gets.strip.to_i
    case @initial_choice
      when 1 then choose_dictionary
      when 2 then choose_opponent
      when 3 then show_options_menu
      when 4 then show_scores
    end
  end
  
  #player methods
  def choose_player
    puts "Please, choose player:"
    all_players = LoadPlayers.load_all_players
    all_players.each_with_index { |player, index| puts "#{index + 1}. #{player['player_name']}"}
    puts "Enter choosen player number:"
    gets.strip.to_i - 1
  end
  
  def choose_opponent
    @opponent_index = choose_player
    choose_dictionary
  end
  
  #option menu methods
  def add_word
    puts "Your word is:"
    word = gets.strip
    puts "Category of your word is:"
    category = gets.strip
    puts "Word description (optionaly):"
    word_description = gets.strip
    if LoadDictionary.add_word({"word" => word.capitalize, "category" => category.capitalize, "description" => word_description.capitalize})
      puts "Your word is succesfully added!"
    else
      puts "There's an error in adding word :/"
    end
  end
  
  def delete_word
    words = LoadDictionary.load_all_words
    words.each_with_index {|word,index| puts "#{index + 1}. #{word['word']}"}
    puts "Type number of word you want to delete:"
    choice = gets.strip.to_i
    if LoadDictionary.delete_word words[choice-1]
      puts "The word is succesfully deleted!"
    else
      puts "There is an error in deleting word :/"
    end
  end
  
  def add_player
    puts "Enter the name of your player:"
    player = gets.strip
    result = LoadPlayers.add_player({"player_name" => player.capitalize, "player_score" => "0"})
    if result == :succesfully_added
      puts "Your player is added correctly."
    elsif result == :duplicated_name
      puts "Enter new name. This is already taken:"
      add_player
    else
      puts "There is an error in adding player."
    end
  end
  
  def delete_player
    players = LoadPlayers.load_all_players
    players.each_with_index {|player,index| puts "#{index + 1}. #{player['player_name']}"}
    puts "Type number of player you want to delete:"
    choice = gets.strip.to_i
    if LoadPlayers.delete_player players[choice-1]
      puts "The player is succesfully deleted!"
    else
      puts "There is an error in deleting player :/"
    end
  end
end
ConsoleMenu.start
