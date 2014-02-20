class GraphicsWindowMenu
  require "green_shoes"
  require "./Model/load_dictionary"
  require "./Model/load_players_list"
  require "./Graphics/drawer"

  def initialize(app)
  	@app = app
  	@main_menu_options = [MENU_AGANST_PC, MENU_MULTYPLAYER, MENU_OPTIONS, MENU_SCORES]
  	@option_menu_options = [OPTIONS_ADD_WORD, OPTIONS_DELETE_WORD, OPTION_ADD_PLAYER, OPTION_DELETE_PLAYER]
  	show_start_menu
  end

  def show_start_menu
  	@main_menu_buttons = @main_menu_options.map do |option|
        				           @app.button "#{option}"
      					         end
  	get_users_choice_for_main_menu
  end   

  private

  MENU_AGANST_PC = "Against PC"
  MENU_MULTYPLAYER = "Multiplayer"
  MENU_OPTIONS = "Options"
  MENU_SCORES = "Scores"
  
 
  
  OPTIONS_ADD_WORD = "Add word"
  OPTIONS_DELETE_WORD = "Delete word"
  OPTION_ADD_PLAYER = "Add player"
  OPTION_DELETE_PLAYER = "Delete player"

  #help methods

  def get_users_choice_for_main_menu
    @main_menu_buttons[0].click do
      @initial_choice = 1
      choose_dictionary 
    end
    @main_menu_buttons[1].click do
      @initial_choice = 2
      choose_dictionary 
    end
    @main_menu_buttons[2].click do
      @initial_choice = 3
      choose_dictionary 
    end
    @main_menu_buttons[3].click do
      @initial_choice = 4
      choose_dictionary 
    end

  end

  # def show_options_for_current_menu(menu)
  # 	@current_menu_buttons = menu.map do |option|
  #       				              @app.button "#{option}" do load_words_from_dictionary LoadDictionary.make_dictionary_by_category option end
  #     					            end
  # end

  # def show_dictionary_options_for(method)
  #   @app.para "Please, choose a dictionary:"
  #   @all_types = method
  #   show_options_for_current_menu @all_types
  # end
  #show menus methods
  
  def choose_dictionary
    @app.para "Do you wanna see categories or word's length? Enter your choice:"
    by_category = @app.button "By category"
    by_category.click { choose_dictionary_by_category }
    by_length = @app.button "By length"
    by_length.click { choose_dictionary_by_length }
  end

  #choose dictionary methods
  
  def choose_dictionary_by_category
    @app.para "Please, choose a dictionary:"
    all_types = LoadDictionary.get_all_categories
    all_types.map do |option|
      @app.button "#{option}" do load_words_from_dictionary LoadDictionary.make_dictionary_by_category option end
    end
  end
  
  def choose_dictionary_by_length
    #choice = show_dictionary_options_for LoadDictionary.get_all_word_lengths
    #load_words_from_dictionary LoadDictionary.make_dictionary_by_word_length @all_types[choice - 1]
  end
  
  def load_words_from_dictionary(dictionary)
    case @initial_choice
      when 1
        game_choice = LoadDictionary.random_word_from_dictionary dictionary        
      when 2
        LoadDictionary.show_dictionary dictionary
        @app.para "Please, enter number of your word"
        game_choice = LoadDictionary.choose_word_from_dictionary dictionary        
    end
    @game = GameLogic.new word: game_choice["word"], category: game_choice["category"], description: game_choice["description"]
    start_game(@game)
  end

  def start_game(game)
    Shoes.app do
      #drawer = Drawer.new
      #loop do
        stack do
          current_alphabet = para "\nYour word's category is: #{game.category}. Your alphabet is : #{game.alphabet.join(", ").upcase}."
          current_pattern = para "Make a guess: #{game.pattern}"
          text_field = edit_line
          make_guess_button = button "Make guess"
          make_guess_button.click do 
            
            guess = text_field.text().strip
            result = game.play(guess)  

            message = ""
            p result
            case result
              when :loss
                message = "You lose, bro... The word is #{game.choosen_word.upcase}."
                make_guess_button.clear()
                text_field.clear
              when :win
                message = "You win! The word is #{game.choosen_word.upcase}."
                # @app.instance_eval{ p @player_index}
                #@opponent_index.nil? ? LoadPlayers.update_user_score(@player_index) : LoadPlayers.update_user_score(@opponent_index)
                make_guess_button.clear()
                text_field.clear
              when :guessed_letter
                message = "Yeah! You rulz :*"
              when :incorrect_letter
                message = para "Nope..."
                #drawer.public_send @draw_hangman_phases[@game.bad_guesses - 1]
                #puts drawer.render_canvas
              when :repeated_letter
                message = "It's not that letter, bro. You've already tried it!"
              # else            
            end
            p message
            para message
            current_alphabet.clear()
            current_alphabet = para "\nYour word's category is: #{game.category}. Your alphabet is : #{game.alphabet.join(", ").upcase}."

            current_pattern.clear()
            current_pattern = para "Make a guess: #{game.pattern}"
          end
        end
      #end
    end
  end
end

Shoes.app do
  GraphicsWindowMenu.new self
end
