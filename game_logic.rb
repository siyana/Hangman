class GameLogic
  
  attr_reader :choosen_word, :category, :alphabet, :pattern, :bad_guesses
  
  def initialize(word)
    @alphabet = (10...36).map { |i| i.to_s 36 }
    #load word from file
    @choosen_word = word["word"].downcase
    @category = word["category"]
    @pattern = make_pattern_for_word @choosen_word.downcase
    @guessed_letters = []
    @bad_guesses = 0
  end
  
  def make_pattern_for_word(word)
    word.tr("a-z", "_")
  end
  
  def play
    if @pattern.include? "_" and @bad_guesses >= 10
      return :loss
    elsif !@pattern.include? "_"
      return :win
    else
      guess = make_guess
      if !@guessed_letters.include? guess and guess
        @guessed_letters << guess
        if check_for_letter guess
          return :guessed_letter
        else
          @bad_guesses = @bad_guesses + 1 if /[[:alpha:]]/.match(guess)
          return :incorrect_letter
        end
        @alphabet.delete_if { |i| i == guess }
      else
        return :repeated_letter
      end
    end
  end
  
  def make_guess
    #get user's letter / show alphabet with left letters
    guess = gets
    /[[:alpha:]]/.match(guess) ? guess.downcase.strip : nil
  end
  
  def check_for_letter(letter)
    #check if choosen word contains letter
    if @choosen_word.include? letter
      @choosen_word = @choosen_word.gsub letter, letter.upcase
      @pattern = make_pattern_for_word @choosen_word
    end
  end
  
end

