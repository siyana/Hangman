class GameLogic
  
  attr_reader :choosen_word, :category, :alphabet, :pattern, :bad_guesses
  
  PATTERN_SYMBOL = '*'
  
  def initialize(word: nil,category: nil,description: nil)
    @alphabet = (10...36).map { |i| i.to_s 36 }
    #load word from file
    @choosen_word = word.downcase
    @initial_word = @choosen_word
    @category = category
    @description = description
    @pattern = make_pattern_for_word @choosen_word.downcase
    @guessed_letters = []
    @bad_guesses = 0
  end
  
  def play(guess)
    return :win if guess == @initial_word
    status = game_continue(guess)
    status = :loss if @pattern.include? PATTERN_SYMBOL and @bad_guesses >= 10
    status = :win unless @pattern.include? PATTERN_SYMBOL
    status
  end
  
  private
  
  def game_continue(guess)
      guess = /[[:alpha:]]/.match(guess) ? guess.downcase.strip : nil
      @alphabet.delete_if { |i| i == guess }
      if !@guessed_letters.include? guess and guess
        @guessed_letters << guess
        return :guessed_letter if check_for_letter guess
        @bad_guesses = @bad_guesses + 1
        return :incorrect_letter
      elsif !guess
        return :not_a_letter
      else
        return :repeated_letter
      end
  end
  
  def make_pattern_for_word(word)
      word.tr("a-z", PATTERN_SYMBOL)
  end

  def check_for_letter(letter)
      #check if choosen word contains letter
      if @choosen_word.include? letter
          @choosen_word = @choosen_word.gsub letter, letter.upcase
          @pattern = make_pattern_for_word @choosen_word
      end
  end
  
end

