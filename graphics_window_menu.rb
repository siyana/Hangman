class GraphicsWindowMenu
  require "green_shoes"
  require "./Model/load_dictionary"
  require "./Model/load_players_list"
  require "./Graphics/drawer"

  attr_accessor :player_index, :opponent_index

  MENU_AGANST_PC = "Against PC"
  MENU_MULTIPLAYER = "Multiplayer"
  MENU_OPTIONS = "Options"
  MENU_SCORES = "Scores"

  def initialize(app)
  	@app = app
  	@main_menu_options = [MENU_AGANST_PC, MENU_MULTIPLAYER, MENU_OPTIONS, MENU_SCORES]
  	choose_player
  end

  def show_start_menu(player_index)
    @app.flow do
    	@main_menu_buttons = @main_menu_options.map do |option|
          				           @app.button "#{option}"
        					         end
    end
  	get_users_choice_for_main_menu(player_index)
  end

  private

  #help methods

  def choose_player
    paragraph = @app.para "Please, choose player:"
    all_players = LoadPlayers.load_all_players
    list = @app.list_box items:all_players.map { |player| player["player_name"] }
    button = @app.button "Choose" do
      all_players.each_with_index { |player, index| @player_index = index if player["player_name"] == list.text() }
      paragraph.clear()
      list.clear()
      button.clear()
      show_start_menu(@player_index)
    end
  end

  def get_users_choice_for_main_menu(player_index)
    @main_menu_buttons[0].click do
      #@initial_choice = MENU_AGANST_PC
      Shoes.app title: "Against PC", width: 400 do
        GameMode.new self,:against_pc, player_index
      end
    end
    @main_menu_buttons[1].click do
      #@initial_choice = MENU_MULTIPLAYER
      Shoes.app title: "Multiplayer", width: 400 do
        GameMode.new self,:against_pc, player_index
      end
    end
    @main_menu_buttons[2].click do
      #@initial_choice = MENU_OPTIONS
      show_options_menu
    end
    @main_menu_buttons[3].click do
      #@initial_choice = MENU_SCORES
      show_scores
    end
  end

  def show_options_menu
    Shoes.app title: "Option menu:", width: 100, height: 200 do
      OptionMenu.new self
    end
  end

  def show_scores
    all_players = LoadPlayers.load_all_players
     scores = all_players.map { |player|  "#{player['player_name']}   #{player['player_score'] }"}.join("\n")
     @app.alert scores
  end

  class GameMode
    def initialize(app,game_mode, player_index)
      @app = app
      @player_index = player_index
      @game_mode = game_mode
      show_proper_menu
    end

    def show_proper_menu
      case @game_mode
        when :against_pc then choose_dictionary
        when :multiplayer then choose_opponent
      end
    end

    def choose_dictionary
      @app.para "Do you wanna see categories or word's length? Enter your choice:"
      by_category = @app.button "By category"
      by_category.click { choose_dictionary_by_category }
      by_length = @app.button "By length"
      by_length.click { choose_dictionary_by_length }
    end  

    #player methods

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
      case @game_mode
        when :against_pc
          game_choice = LoadDictionary.random_word_from_dictionary dictionary
          @game = GameLogic.new word: game_choice["word"], category: game_choice["category"], description: game_choice["description"]
          start_game(@game, @player_index, @opponent_index)
        when :multiplayer
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
      Shoes.app title: "Let's play a game", width: 400, height: 200 do
        GraphicsWindowMenu::StartGame.new self, game, player_index, opponent_index
      end
    end    
  end

  class StartGame

    def initialize(app, game, player_index, opponent_index)
      @app = app
      @game = game
      @player_index = player_index
      @opponent_index = opponent_index
      start_game
    end

    def start_game
      @text_field = @app.edit_line
      @make_guess_button = @app.button "Make guess"
      show_alphabet
      show_pattern
      @make_guess_button.click do make_guess @text_field.text().lstrip end
    end

    def show_alphabet
      @current_alphabet.clear() unless @current_alphabet.nil?
      @current_alphabet = @app.para "\nYour word's category is: #{@game.category}. Your alphabet is : #{@game.alphabet.join(", ").upcase}."
    end

    def show_pattern
      @current_pattern.clear() unless @current_pattern.nil?
      @current_pattern = @app.caption "Make a guess: #{@game.pattern}"
    end

    def make_guess(guess)
      result = @game.play(guess)
      case result
        when :loss
          @app.alert "You lose, bro... The word is #{@game.choosen_word.upcase}."
          @make_guess_button.clear()
          @text_field.clear()
        when :win
          @app.alert "You win! The word is #{@game.choosen_word.upcase}."
          result = @opponent_index.nil? ? LoadPlayers.update_player_score(@player_index) : LoadPlayers.update_player_score(@opponent_index)
          if result != :guest
            @app.alert "#{LoadPlayers.get_player_name @opponent_index.nil? ? @player_index : @opponent_index} has
                   #{LoadPlayers.get_player_score @opponent_index.nil? ? @player_index : @opponent_index} points"
          else
            @app.alert "You're guest. To create new player go to options menu"
          end
          @make_guess_button.clear()
          @text_field.clear()
        when :guessed_letter
          @app.alert "Yeah! You rulz :*"
        when :incorrect_letter
          @app.alert "Nope... You have #{10 - @game.bad_guesses} attempts remaining "
        when :repeated_letter
          @app.alert "It's not that letter, bro. You've already tried it!"
        when :not_a_letter
          puts "Please, enter a letter"
      end
      show_alphabet
      show_pattern
    end

  end

  class OptionMenu
    OPTIONS_ADD_WORD = "Add word"
    OPTIONS_DELETE_WORD = "Delete word"
    OPTION_ADD_PLAYER = "Add player"
    OPTION_DELETE_PLAYER = "Delete player"
    def initialize(app)
      @app = app
      @option_menu_options = [OPTIONS_ADD_WORD, OPTIONS_DELETE_WORD, OPTION_ADD_PLAYER, OPTION_DELETE_PLAYER]
      show_options_menu
    end

    def show_options_menu
      @app.stack do
        @option_menu_options.map do |option|
          @app.button "#{option}" do
            case option
              when OPTIONS_ADD_WORD then add_word
              when OPTIONS_DELETE_WORD then delete_word
              when OPTION_ADD_PLAYER then add_player
              when OPTION_DELETE_PLAYER then delete_player
            end
          end
        end
      end
    end

    private

    def add_player
      Shoes.app title: "Add player:", width: 300, height: 100 do
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
          close
        end
      end
    end#end add_player

    def add_word
      Shoes.app title: "Add your word:", width: 300, height: 200 do
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
          close
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
              close
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
              close
            end
          end
        end
      end
    end#end delete_player
  end
end

Shoes.app  title: "Hangman", width: 350, height: 100, scroll: true do
  GraphicsWindowMenu.new self
end
