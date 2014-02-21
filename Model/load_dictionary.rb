module LoadDictionary
  require "json"
  require_relative "game_logic"
  extend self

  WORD_DICTIONARY = "./Model/words_dictionary.json"

  #dictionary methods
  def load_all_words
    JSON.parse(IO.read WORD_DICTIONARY)
  end

  def get_all_categories
    load_all_words.map { |word| word["category"]}.uniq
  end

  def get_all_word_lengths
    load_all_words.map { |word| word["word"].length}.uniq.sort
  end

  def random_word_from_dictionary(dictionary)
    dictionary.sample
  end

  def choose_word_from_dictionary(dictionary, choice)
    dictionary[choice]
  end

  def make_dictionary_by_category(words = load_all_words, category)
    category_dictionary = []
    words.each do |word|
      category_dictionary << word if word["category"] == category
    end
    @current_dictionary = category_dictionary
  end

  def make_dictionary_by_word_length(words = load_all_words, length)
    length_dictionary = []
    words.each do |word|
      length_dictionary << word if word["word"].length == length
    end
    @current_dictionary = length_dictionary
  end

  #word methods
  def add_word(word)
    return :not_valid unless /[[:alpha:]]/.match(word["word"])
    word["word"] = word["word"].strip.capitalize
    all_words = load_all_words
    delete_repeated_or_choosen all_words, word
    all_words << word
    write_to_json all_words
  end

  def delete_word(word)
      # dont delete word which is not contained
    all_words = load_all_words
    delete_repeated_or_choosen all_words, word
    write_to_json all_words
  end

  private

  def write_to_json(records)
    File.open(WORD_DICTIONARY,"w") do |f|
      f.write(JSON.pretty_generate(records))
    end
  end

  def delete_repeated_or_choosen(all_words,word)
    all_words.delete_if { |current_word| current_word == word}
  end

end

