class GameLogic
  
  attr_reader :choosen_word
  
  def initialize(word)
    @alphabet = (10...36).map { |i| i.to_s 36 }
    #load word from file
    @choosen_word = word["word"].downcase
    @category = word["category"]
    @pattern = make_pattern_for_word @choosen_word.downcase
    @guessed_letters = []
    play
  end
  
  def make_pattern_for_word(word)
    word.tr "a-z", "_"
  end
  
  def play    
    bad_guesses = 0
    loop do
      if @pattern.include? "_" and bad_guesses >= @choosen_word.length
        puts "You lose, bro... The word is #{@choosen_word.upcase}."
        break
      elsif !@pattern.include? "_"
        puts "You win! The word is #{@choosen_word.upcase}."
        break
      else
        puts "\nYour word's category is: #{@category}. Your alphabeth is : #{@alphabet.join(", ").upcase}."
        guess = make_guess
        if !@guessed_letters.include? guess
          @guessed_letters << guess
          if check_for_letter guess
            puts "Yeah! You rulz :*"
          else
            bad_guesses = bad_guesses + 1
            puts "Nope..."
          end
          @alphabet.delete_if { |i| i == guess }
        else
          puts "It's not that letter, bro. You've already tried it!"
        end
      end
    end
  end
  
  def make_guess
    #get user's letter / show alphabet with left letters
    puts "Make a guess: #{@pattern}"
    gets.downcase.strip    
  end
  
  def check_for_letter(letter)
    #check if choosen word contains letter
    if @choosen_word.include? letter
      @choosen_word = @choosen_word.gsub letter, letter.upcase
      @pattern = make_pattern_for_word @choosen_word
    end
  end
  
end

