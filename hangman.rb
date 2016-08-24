require 'yaml'

class Hangman
  attr_accessor :chosen_word, :guess, :answers, :hidden, :misses

  def initialize
    @chosen_word = nil
    @guess = nil
    @answers = nil
    @hidden = []
    @misses = []
    puts "Welcome to a new round of Hangman!",""
    load_your_game?
  end

  def new_game
    puts "New word selected!",""
    choose_word
    puts "WORD: " + @answers = @chosen_word.gsub(/[A-Z]/,' _ '),""
    play
  end

  def resume_game
    puts "Resuming your game.",""
    letters = @hidden.to_s #converting to string
    puts "WORD: " + @answers = @chosen_word.gsub(/[^#{letters}]/, " _ "),""
    play
  end

  def display_poor_sod
  count = @misses.length
    case count
    when 1 then puts "           O ",""
    when 2 then puts "           O ","          -  ",""
    when 3 then puts "           O ","          -| ",""
    when 4 then puts "           O ","          -|-",""
    when 5 then puts "           O ","          -|-","           | ",""
    when 6 then puts "           O ","          -|-","           | ","          -  ",""
    when 7 then puts "           O ","          -|-","           | ","          - -","hangman",""
    else

    end
  end

  def play
    puts "MISSES: " + @misses.join(", ") ,""
    while !game_over?
      round
    end
    if win?
      puts "You win! You winning winner, you!",""
      play_again?
    elsif lose?
      puts "Sorry, you lose this time.",""
      puts "The word was: " + @chosen_word ,""
      play_again?
    end
  end


  def choose_word

    suitable_words = []

    File.readlines("5desk.txt").each do |word| word
      word.gsub!("\n", "")

      if word.length >= 5 && word.length <= 12
          suitable_words << word.upcase
      end
    end
      @chosen_word = suitable_words.sample.to_s
  end

  def round
      player_guess
      answer
      display_poor_sod
  end

  def player_guess
    loop do
    puts  "Guess a letter or enter + to save your game:",""
    @guess = gets.chomp.upcase.to_s

      if @guess.empty?
        puts "C'mon now, enter something, like a letter:",""
      elsif @guess.match(/[A-Z+]/).nil? == true
        puts "Letters only, no lollygagging.",""
      elsif @hidden.include?(@guess) || @misses.include?(@guess)
        puts "You already guessed that letter, try again.",""
      elsif @guess.length > 1
        puts "Only enter one letter."
      elsif @guess == "+"
        save_game
      else
        break
      end
    end
    unless @guess == "+"
    puts "Your guess: " + @guess ,""
    end
  end

  def answer
    if @chosen_word.include? @guess
      @hidden << @guess #shoveling guess into an array
      letters = @hidden.to_s #converting to string
    puts "WORD: " + @answers = @chosen_word.gsub(/[^#{letters}]/, " _ "),""
    puts "MISSES: " + @misses.join(", "),""
    else
      @misses = @misses << @guess
      puts "WORD: " + @answers ,""
      puts "MISSES: " + @misses.join(", "),""
    end
  end

  def win?
     @answers == @chosen_word
  end

  def lose?
    @misses.length == 7
  end

  def game_over?
    win? || lose?
  end

  def play_again?
    again = false
    while again == false
      print "Would you like to play again? (y/n): "
      input = gets.chomp.downcase
      if input == "y"
        again = true
        load './hangman.rb'
      elsif input == 'n'
        again = true
        exit
      else
        puts "Invalid input, please enter either 'y' or 'n' you hooligan."
      end
    end
  end

  def load_your_game?
    load_it = false
    while load_it == false
      print "Would you like to load an existing game? (y/n): "
      input = gets.chomp.downcase
      if input == "y"
        load_it = true
         load_game
         resume_game
      elsif input == 'n'
        load_it = true
        new_game
      else
        puts "Invalid input, please enter either 'y' or 'n' you hooligan."
      end
    end
  end
  def save_game
    game_file = File.new('saved.yaml', 'w')
    game_file.puts YAML.dump({
        :chosen_word => @chosen_word,
        :guess => @guess,
        :answers => @answers,
        :hidden => @hidden,
        :misses => @misses,
        })
      game_file.close
      puts "Game saved!"
  end

  def load_game
      game_file = YAML.load_file('saved.yaml')
      game_file.each do |key, value|
        instance_variable_set(:"@#{key}", value)
      end
  end
end


newgame = Hangman.new
