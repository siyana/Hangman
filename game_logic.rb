class GameLogic
  
  attr_reader :choosen_word
  
  def initialize(word)
    @alphabet = (10...36).map { |i| i.to_s 36 }
    #load word from file
    @choosen_word = word["word"].downcase
    @category = word["category"]
    @pattern = make_pattern_for_word @choosen_word.downcase
    play
  end
  
  def make_pattern_for_word(word)
    word.tr "a-z", "_"
  end
  
  def play    
    bad_guesses = 0
    loop do
      puts @pattern
      if @pattern.include? "_" and bad_guesses >= 6
        puts "You loose, bro..."
      elsif !@pattern.include? "_"
        puts "You win!"
        break
      else
        puts "Your word's category is: #{@category}. Your alphabeth is : #{@alphabet.join(", ").upcase}."
        guess = make_guess
        if check_for_letter guess
          puts "Yeah! You rulz :*"
        else
          bad_guesses += bad_guesses
          puts "Nope..."
        end        
        @alphabet.delete_if { |i| i == guess }
      end
    end
  end
  
  def make_guess
    #get user's letter / show alphabet with left letters
    puts "Make a guess:"
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

