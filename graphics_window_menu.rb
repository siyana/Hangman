class GraphicsWindowMenu
  require "green_shoes"
  require "./Model/load_dictionary"
  require "./Model/load_players_list"
  require "./Graphics/drawer"

  attr_accessor :player_index, :opponent_index


  def initialize(app)
  	@app = app
  	@main_menu_options = [MENU_AGANST_PC, MENU_MULTIPLAYER, MENU_OPTIONS, MENU_SCORES]
  	choose_player
  end

  def show_start_menu
    @app.flow do 
    	@main_menu_buttons = @main_menu_options.map do |option|
          				           @app.button "#{option}"
        					         end
    end
  	get_users_choice_for_main_menu
  end   

  private

  MENU_AGANST_PC = "Against PC"
  MENU_MULTIPLAYER = "Multiplayer"
  MENU_OPTIONS = "Options"
  MENU_SCORES = "Scores" 
  
  OPTIONS_ADD_WORD = "Add word"
  OPTIONS_DELETE_WORD = "Delete word"
  OPTION_ADD_PLAYER = "Add player"
  OPTION_DELETE_PLAYER = "Delete player"

  #help methods

  def get_users_choice_for_main_menu
    @main_menu_buttons[0].click do
      @initial_choice = MENU_AGANST_PC
      choose_dictionary 
    end
    @main_menu_buttons[1].click do
      @initial_choice = MENU_MULTIPLAYER
      choose_opponent 
    end
    @main_menu_buttons[2].click do
      @initial_choice = MENU_OPTIONS
      show_options_menu
    end
    @main_menu_buttons[3].click do
      @initial_choice = MENU_SCORES
      show_scores 
    end
  end

  def show_options_menu
    Shoes.app title: "Option menu:", width: 100, height: 200 do
      stack do 
        option_menu_options = [OPTIONS_ADD_WORD, OPTIONS_DELETE_WORD, OPTION_ADD_PLAYER, OPTION_DELETE_PLAYER]
        option_menu_options.map do |option|
          button "#{option}" do
            case option
              when OPTIONS_ADD_WORD then add_word
              when OPTIONS_DELETE_WORD then delete_word
              when OPTION_ADD_PLAYER then add_player
              when OPTION_DELETE_PLAYER then delete_player
            end
          end
        end

        def add_player
          Shoes.app title: "Add player:", width: 200, height: 100 do
            para "Player name:"
            player_field = edit_line
            button "Add player" do
              result = LoadPlayers.add_player({"player_name" => player_field.text().capitalize, "player_score" => 0})
              if result == :succesfully_added
                alert "Your player is added correctly."
              elsif result == :duplicated_name
                alert "Enter new name. This is already taken:"
              else
                alert "There is an error in adding player."
              end
            end
          end
        end#end add_player

        def add_word
          Shoes.app title: "Add your word:" do
            para "Word:"
            word_field = edit_line
            para "Category of your word is:"
            category_field = edit_line
            para "Word description (optionaly):"
            word_description_field = edit_line
            button "Add word" do
              if LoadDictionary.add_word({"word" => word_field.text().capitalize, "category" => category_field.text().capitalize, "description" => word_description_field.text().capitalize})
                alert "Your word is succesfully added!"
              else
                alert "There's an error in adding word :/"
              end
            end
          end
        end#end add_word

        def delete_word
          Shoes.app title: "Choose word to delete", width:200 do
            words = LoadDictionary.load_all_words
            stack do              
              words.map do |word|
                button word["word"] do
                  if LoadDictionary.delete_word word
                    alert "The word is succesfully deleted!"
                  else
                    alert "There is an error in deleting word :/"
                  end
                end
              end
            end
          end
        end#end delete_word

        def delete_player
          Shoes.app title: "Choose player to delete", width:200 do
            players = LoadPlayers.load_all_players
            stack do
              players.map do |player| 
                button player['player_name'] do
                  if LoadPlayers.delete_player player
                    alert "The player is succesfully deleted!"
                  else
                    alert "There is an error in deleting player :/"
                  end
                end
              end
            end
          end
        end#end delete_player

      end
      #get_users_choice_for_option_menu
    end
  end

  def show_scores
    all_players = LoadPlayers.load_all_players
     scores = all_players.map { |player|  "#{player['player_name']}   #{player['player_score'] }"}.join("\n")
     @app.alert scores
  end

  def choose_dictionary
    @app.para "Do you wanna see categories or word's length? Enter your choice:"
    by_category = @app.button "By category"
    by_category.click { choose_dictionary_by_category }
    by_length = @app.button "By length"
    by_length.click { choose_dictionary_by_length }
  end

  #player methods

  def choose_player
    paragraph = @app.para "Please, choose player:"
    all_players = LoadPlayers.load_all_players
    list = @app.list_box items:all_players.map { |player| player["player_name"] }
    button = @app.button "Choose" do 
      all_players.each_with_index { |player, index| @player_index = index if player["player_name"] == list.text() }
      paragraph.clear()
      list.clear()
      button.clear()
      show_start_menu
    end   
  end
  
  def choose_opponent
    paragraph = @app.para "Please, choose opponent:"
    all_players = LoadPlayers.load_all_players
    players_names = all_players.select { |player,index| player["player_name"] != all_players[@player_index]["player_name"] }
    list = @app.list_box items:players_names.map { |player| player["player_name"]}
    button = @app.button "Choose" do 
      all_players.each_with_index { |player, index| @opponent_index = index if player["player_name"] == list.text() }
      paragraph.clear()
      list.clear()
      button.clear()
      choose_dictionary
    end   
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
    @app.para "Please, choose a dictionary:"
    all_types = LoadDictionary.get_all_word_lengths
    all_types.map do |option|
      @app.button "#{option}" do load_words_from_dictionary LoadDictionary.make_dictionary_by_word_length option end
    end
  end
  
  def load_words_from_dictionary(dictionary)
    case @initial_choice
      when MENU_AGANST_PC
        game_choice = LoadDictionary.random_word_from_dictionary dictionary
        @game = GameLogic.new word: game_choice["word"], category: game_choice["category"], description: game_choice["description"]
        start_game(@game, @player_index, @opponent_index)        
      when MENU_MULTIPLAYER        
        @app.para "Please, choose a word"
        dictionary.each_with_index do |word, index|
          @app.button "#{word['word']}" do 
            game_choice = LoadDictionary.choose_word_from_dictionary dictionary, index 
            @game = GameLogic.new word: game_choice["word"], category: game_choice["category"], description: game_choice["description"]
            start_game(@game, @player_index, @opponent_index)
          end
        end  
    end    
  end

  def start_game(game, player_index, opponent_index)
    Shoes.app do
      stack do  
        #drawer = Drawer.new 30, 13
        draw_hangman_phases = [:draw_bottom_gibbet_line,
                          :draw_vertical_gibbet_line,
                          :draw_top_gibbet_line,
                          :draw_small_vertical_gibbet_line,
                          :draw_hangman_head,
                          :draw_hangman_body,
                          :draw_hangman_right_arm,
                          :draw_hangman_left_arm,
                          :draw_hangman_right_foot,
                          :draw_hangman_left_foot]       
        text_field = edit_line
        make_guess_button = button "Make guess"
        current_alphabet = para "\nYour word's category is: #{game.category}. Your alphabet is : #{game.alphabet.join(", ").upcase}."
        current_pattern = para "Make a guess: #{game.pattern}"
        message = para ''
        hangman = ''
        make_guess_button.click do           
          guess = text_field.text().strip
          result = game.play(guess)  
          message.clear()
          case result
            when :loss
              message = para "You lose, bro... The word is #{game.choosen_word.upcase}."
              make_guess_button.clear()
              text_field.clear
            when :win
              message = para "You win! The word is #{game.choosen_word.upcase}."
              opponent_index.nil? ? LoadPlayers.update_player_score(player_index) : LoadPlayers.update_player_score(opponent_index)
              alert "#{LoadPlayers.get_player_name opponent_index.nil? ? player_index : opponent_index} has
                     #{LoadPlayers.get_player_score opponent_index.nil? ? player_index : opponent_index} points"
              make_guess_button.clear()
              text_field.clear
            when :guessed_letter
              message = para "Yeah! You rulz :*"
            when :incorrect_letter
              # hangman.clear()
              # drawer.public_send draw_hangman_phases[game.bad_guesses - 1]
              # hangman = para drawer.render_canvas
              message = para "Nope..."
            when :repeated_letter
              message = "It's not that letter, bro. You've already tried it!"
            # else            
          end
          current_alphabet.clear()
          current_alphabet = para "\nYour word's category is: #{game.category}. Your alphabet is : #{game.alphabet.join(", ").upcase}."

          current_pattern.clear()
          current_pattern = para "Make a guess: #{game.pattern}"
        end
      end
    end
  end
end

Shoes.app  title: "Hangman", width: 400, height: 100, scroll: true do
  GraphicsWindowMenu.new self
end
