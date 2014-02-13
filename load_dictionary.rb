class LoadDictionary
  require "json"
  require "./game_logic"
  
  WORD_DICTIONARY = "./words_dictionary.json"
  #@current_dictionary?
  def load_all_words
    #load word_dictionary
    all_words = JSON.parse (IO.read WORD_DICTIONARY)
    make_dictionary_by_word_length all_words, 6
    make_dictionary_by_category all_words, "City"
    choose_word_from_dictionary @current_dictionary
  end
  
  def random_word_from_dictionary(dictionary)
    #code
    dictionary.sample
  end
  
  def choose_word_from_dictionary(dictionary)
      show_dictionary dictionary
      puts "Please, enter number of your word"
      #are you sure?
      GameLogic.new dictionary[gets.to_i - 1]
  end
  
  def show_dictionary(dictionary)
    dictionary.each_with_index do |word, index|
        puts "#{index + 1}. #{word['word']}"
    end
  end
  
  def make_dictionary_by_category(words, category)
    category_dictionary = []
    words.each do |word|
      category_dictionary << word if word["category"] == category
    end
    @current_dictionary = category_dictionary
  end
  
  def make_dictionary_by_word_length(words, length)
    #words with length <= length => diff levels
    length_dictionary = []
    words.each do |word|
      length_dictionary << word if word["word"].length <= length
    end
    @current_dictionary = length_dictionary
  end
end

LoadDictionary.new.load_all_words