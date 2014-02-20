class GameLogic
  
  attr_reader :choosen_word, :category, :alphabet, :pattern, :bad_guesses
  
  def initialize(word: nil,category: nil,description: nil)
    @alphabet = (10...36).map { |i| i.to_s 36 }
    #load word from file
    @choosen_word = word.downcase
    @category = category
    @pattern = make_pattern_for_word @choosen_word.downcase
    @guessed_letters = []
    @bad_guesses = 0
  end
  
  def play(guess)    
    if @pattern.include? "_" and @bad_guesses >= 10
      return :loss
    elsif !@pattern.include? "_"
      return :win
    else
      game_continue(guess)
      
    end
  end
  
  private
  
  def game_continue(guess)
    #guess = make_guess
    /[[:alpha:]]/.match(guess) ? guess.downcase.strip : nil
    @alphabet.delete_if { |i| i == guess }
    if !@guessed_letters.include? guess and guess
      @guessed_letters << guess
      return :guessed_letter if check_for_letter guess
      @bad_guesses = @bad_guesses + 1 #if /[[:alpha:]]/.match(guess)
      return :incorrect_letter
    else
      return :repeated_letter
    end
  end
  
  def make_pattern_for_word(word)
      word.tr("a-z", "_")
  end
  
  # def make_guess
  #   #get user's letter / show alphabet with left letters
  #   guess = gets
  #   /[[:alpha:]]/.match(guess) ? guess.downcase.strip : nil
  # end
  
  def check_for_letter(letter)
    #check if choosen word contains letter
    if @choosen_word.include? letter
      @choosen_word = @choosen_word.gsub letter, letter.upcase
      @pattern = make_pattern_for_word @choosen_word
    end
  end
  
end

