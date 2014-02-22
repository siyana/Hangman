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
  MENU_MULTIPLAYER = "Multiplayer"
  MENU_OPTIONS = "Options"
  MENU_SCORES = "Scores"
  MENU_EXIT = "Exit"

  @main_menu_options = [MENU_AGANST_PC, MENU_MULTIPLAYER, MENU_OPTIONS, MENU_SCORES, MENU_EXIT]

  OPTIONS_ADD_WORD = "Add word"
  OPTIONS_DELETE_WORD = "Delete word"
  OPTION_ADD_PLAYER = "Add player"
  OPTION_DELETE_PLAYER = "Delete player"
  OPTION_GET_BACK = "Get back"

  @option_menu_options = [OPTIONS_ADD_WORD, OPTIONS_DELETE_WORD, OPTION_ADD_PLAYER, OPTION_DELETE_PLAYER, OPTION_GET_BACK]

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
    if LoadDictionary.load_all_words.empty?
      puts "There's no words. Please, add some in menu options."
      show_start_menu
    else
      puts "Do you wanna see categories or word's length? Enter your choice:"
      show_options_for_menu ["By category", "By length"]
      choice = gets.strip.to_i
      case choice
        when 1 then choose_dictionary_by_category
        when 2 then choose_dictionary_by_length
        else
          puts "Please, enter valid choice!"
          choose_dictionary
      end
    end
  end

  def show_options_menu
    puts "Option menu:"
    show_options_for_menu @option_menu_options
    get_users_choice_for_option_menu
  end

  def show_scores
    all_players = LoadPlayers.load_all_players
    all_players.map { |player| puts "#{player['player_name']}   #{player['player_score']}"}
    puts "Press any key to get back to start menu:"
    gets.strip
    show_start_menu    
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
        show_dictionary dictionary
        puts "Please, enter number of your word"
        choice = gets.to_i - 1
        game_choice = LoadDictionary.choose_word_from_dictionary dictionary, choice
    end
    @game = GameLogic.new word: game_choice["word"], category: game_choice["category"], description: game_choice["description"]
    start_game
  end

  def start_game
    drawer = Drawer.new 30,13
    loop do
      puts "\nYour word's category is: #{@game.category}. Your alphabet is : #{@game.alphabet.join(", ").upcase}."
      puts "Make a guess: #{@game.pattern}"
      guess = gets.strip
      result = @game.play(guess)
      case result
        when :loss
          puts "You lose, bro... The word is #{@game.choosen_word.upcase}."
          break
        when :win
          puts "You win! The word is #{@game.choosen_word.upcase}."
          @opponent_index.nil? ? LoadPlayers.update_player_score(@player_index) : LoadPlayers.update_player_score(@opponent_index)
          break
        when :guessed_letter
          puts "Yeah! You rulz :*"
        when :incorrect_letter
          puts "Nope..."
          drawer.public_send @draw_hangman_phases[@game.bad_guesses - 1]
          puts drawer.render_canvas
        when :repeated_letter
          puts "It's not that letter, bro. You've already tried it!"
        when :not_a_letter
          puts "Please, enter a letter"
      end
    end
  end

  #help methods

  def show_dictionary(dictionary)
    dictionary.each_with_index do |word, index|
      puts "#{index + 1}. #{word['word']}"
    end
  end
  def show_options_for_menu(menu)
    menu.each_with_index do |option, index|
      puts "#{index + 1}. #{option}"
    end
  end

  def show_dictionary_options_for(method)
    puts "Please, choose a dictionary:"
    @all_types = method
    show_options_for_menu @all_types
    choice = gets.strip.to_i
    unless choice < @all_types.length and choice >= 0
      puts "Please, enter valid dictionary number next time! Now you will get random dictionary."
      choice = 0
    end
    choice
  end

  def get_users_choice_for_option_menu
    puts "Please, enter the number of your choice:"
    choice = gets.strip.to_i
    case choice
    when 1 then add_word
    when 2 then delete_word
    when 3 then add_player
    when 4 then delete_player
    when 5 then show_start_menu
    else
      puts "Please, enter valid number! This is not a valid choice!"
      show_options_menu
      return
    end
    show_start_menu
  end

  def get_users_choice_for_main_menu
    puts "Please, enter the number of your choice:"
    @initial_choice = gets.strip.to_i
    case @initial_choice
      when 1 then choose_dictionary
      when 2 then choose_opponent
      when 3 then show_options_menu
      when 4 then show_scores
      when 5 then return
      else
        puts "Please, enter valid number! This is not a valid choice!"
        show_start_menu
    end
  end

  #player methods
  def choose_player
    all_players = LoadPlayers.load_all_players
    if all_players.empty?
      return puts "There's no players. Please add some."
    elsif @player_index and all_players.length == 1
      return puts "There's no other players. Please add some."
    end
    puts "Please, choose player:"
    all_players.each_with_index { |player, index| puts "#{index + 1}. #{player['player_name']}" if index != @player_index}
    puts "Enter choosen player number:"
    choice = gets.strip.to_i - 1
    unless choice < all_players.length and choice >= 0 and choice != @player_index
      puts "Please, enter valid player number!"
      choose_player
    end
    choice
  end

  def choose_opponent
    @opponent_index = choose_player
    if @opponent_index
      choose_dictionary
    else
      puts "You cant play multiplayer because there're no other players, please add or choose 'Against PC'."
      show_start_menu
    end
  end

  #option menu methods
  def add_word
    puts "Your word is:"
    word = gets.strip
    puts "Category of your word is:"
    category = gets.strip
    puts "Word description (optionaly):"
    word_description = gets.strip
    result = LoadDictionary.add_word({"word" => word.capitalize, "category" => category.capitalize, "description" => word_description.capitalize})
    if result and result != :not_valid
      puts "Your word is succesfully added!"
    elsif result == :not_valid
      puts "This is not a valid word. Please, use only letters"
      add_word
    else
      puts "There's an error in adding word :/"
      add_word
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
    result = LoadPlayers.add_player({"player_name" => player, "player_score" => 0})
    case result
      when :succesfully_added then puts "Your player is added correctly."
      when :duplicated_name
        puts "Enter new name. This is already taken:"
        add_player
      when :not_valid
        puts "This is not valid name! The name should concist only letters."
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
