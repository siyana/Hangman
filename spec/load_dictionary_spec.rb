require_relative "spec_helper.rb"
require "json"

describe LoadDictionary do
  let(:json_records) { JSON.parse(IO.read "./Model/words_dictionary.json") }
  describe "#load_all_words" do
    it "should load words for dictionary from json" do
      LoadDictionary.load_all_words.should eq json_records
    end
  end
  
  describe "#get_all_categories" do
    it "should not load repeated categories" do
      LoadDictionary.get_all_categories.should_not eq json_records.map { |word| word["category"]}
    end
    it "should load all uniq categories" do
        LoadDictionary.get_all_categories.should eq json_records.map { |word| word["category"]}.uniq
    end
  end
  
  describe "#get_all_word_lengths" do
    it "should not load repeated lengths" do
      LoadDictionary.get_all_word_lengths.should_not eq json_records.map { |word| word["word"].length}
    end
    it "should load all uniq lengths sorted in ascending order" do
      LoadDictionary.get_all_word_lengths.should eq json_records.map { |word| word["word"].length}.uniq.sort
    end
  end
  
  describe "#make_dictionary_by_category" do
    it "should load dictionary only from words in current category" do
      dictionary = LoadDictionary.make_dictionary_by_category "Name"
      test_dictionary = []
      json_records.each do |word|
        test_dictionary << word if word["category"] == "Name"
      end
      dictionary.should eq test_dictionary
    end
  end
  
  describe "#make_dictionary_by_word_length" do
    it "should load dictionary only from words with current length" do
      dictionary = LoadDictionary.make_dictionary_by_word_length 5
      test_dictionary = []
      json_records.each do |word|
        test_dictionary << word if word["word"].length == 5
      end
      dictionary.should eq test_dictionary
    end
  end

  
  describe "#random_word_from_dictionary" do
    it "should load word from current dictionary by category" do
      dictionary = LoadDictionary.make_dictionary_by_category "Name"
      random_word = LoadDictionary.random_word_from_dictionary dictionary
      dictionary.include? random_word.should be_true
    end
    
    it "should load word from current dictionary by category" do
      dictionary = LoadDictionary.make_dictionary_by_word_length 5
      random_word = LoadDictionary.random_word_from_dictionary dictionary
      dictionary.include? random_word.should be_true
    end
    
    it "should load random word from current dictionary by category" do
       
    end
  end
  
  describe "#choose_word_from_dictionary" do
    it "should load choosen word from dictionary by category" do
      dictionary = LoadDictionary.make_dictionary_by_category "Name"
      LoadDictionary.choose_word_from_dictionary(dictionary, 1).should eq dictionary[1]
    end
    
    it "should load choosen word from dictionary by length" do
      dictionary = LoadDictionary.make_dictionary_by_word_length 5
      LoadDictionary.choose_word_from_dictionary(dictionary, 1).should eq dictionary[1]
    end
  end
  
  describe "#add_word" do
    it "should add word to json file" do
      added_word = {"word" => "new word".capitalize, "category" => "new category".capitalize, "description" => "this is desc".capitalize}
      LoadDictionary.add_word added_word
      json_records.any? { |word| word['word'] == added_word['word']}.should be_true
    end
    it "should not duplicated words in json file" do
        added_word = {"word" => "new word".capitalize, "category" => "new category".capitalize, "description" => "this is desc".capitalize}
        LoadDictionary.add_word(added_word)
        added_word = {"word" => "new word".capitalize, "category" => "new category".capitalize, "description" => "this is desc".capitalize}
        json_records.select { |word| word['word'] == added_word['word']}.length.should eq 1
    end
  end
  
  describe "#delete_word" do
    it "should delete word from json file" do
      delete_word = {"word" => "new word".capitalize, "category" => "new category".capitalize, "description" => "this is desc".capitalize}
      LoadDictionary.delete_word delete_word
      json_records.none? { |word| word['word'] == delete_word['word']}.should be_true
    end
  end
end