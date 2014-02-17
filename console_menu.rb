module ConsoleMenu
  extend self
  require "./load_dictionary"
  require "./Graphics/drawer"
  
  def show_start_menu
    show_options_for_menu @menu_options
    get_users_choice_for_menu
  end
  
  private
  
  MENU_AGANST_PC = "Against PC"
  MENU_MULTYPLAYER = "Multyplayer"
  MENU_OPTIONS = "Options"
  MENU_SCORES = "Scores"
  
  @menu_options = [MENU_AGANST_PC, MENU_MULTYPLAYER, MENU_OPTIONS, MENU_SCORES]
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
  
  def get_users_choice_for_menu
      puts "Please, enter the number of your choice:"
      @initial_choice = gets.strip.to_i
      case @initial_choice
          when 1, 2 then choose_dictionary
          when 3 then show_options_menu
          when 4 then show_scores
      end
  end
  
  def choose_dictionary
    puts "Do you wanna see categories or word's length? Enter your choice:"
    show_options_for_menu ["By category", "By length"]
    choice = gets.strip.to_i
    case choice
      when 1
       choose_dictionary_by_category
      when 2
       choose_dictionary_by_length
    end
  end
  
  def show_options_menu
    p "3"
  end
  
  def show_scores
    p "4"
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
    puts "\nYour word's category is: #{@game.category}. Your alphabeth is : #{@game.alphabet.join(", ").upcase}."
    drawer = Drawer.new
    loop do
      puts "Make a guess: #{@game.pattern}"
      result = @game.play
      case result
        when :loss
          puts "You lose, bro... The word is #{@game.choosen_word.upcase}."
          break
        when :win
          puts "You win! The word is #{@game.choosen_word.upcase}."
          break
        when :guessed_letter
          puts "Yeah! You rulz :*"
        when :incorrect_letter
          puts "Nope..."
          drawer.public_send @draw_hangman_phases[@game.bad_guesses - 1]
          puts drawer.render_canvas
          puts "\nYour word's category is: #{@game.category}. Your alphabeth is : #{@game.alphabet.join(", ").upcase}."
        when :repeated_letter
          puts "It's not that letter, bro. You've already tried it!"
        else
        
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
  
end

ConsoleMenu.show_start_menu