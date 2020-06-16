require "yaml"

class Hangman
  def initialize
    @rand_word = get_random_word
    @guessed = []
    @display = "_ "*@rand_word.length
  end

  def get_random_word 
    words = Array.new
  
    File.open("5desk.txt").readlines.each do |word|
      words.push(word.chomp)
    end
  
    words[Random.rand(words.length)]
  end
  
  def make_guess(guess)
    used = false
    for i in 0..@rand_word.length-1
      if @rand_word[i,1].downcase == guess.downcase
        @display[i*2] = guess
        used = true
      end
    end
    if !used && @guessed.index(guess) == nil
      @guessed.push(guess)
    end 
  end

  def play
  man_drawing = ["\n\n\n\n\n", "      ()\n\n\n\n", "      ()\n      @@\n\n\n", "      ()\n     /@@\n\n\n",
                 "      ()\n     /@@\\\n\n\n", "      ()\n     /@@\\\n      /\n\n",
                 "      ()\n     /@@\\\n      /\\\n\n"]
    until @guessed.length == 6 || @display.index("_") == nil do
      puts "#{man_drawing[@guessed.length]}#{@display}\nLetters guessed incorrectly: #{@guessed.join(" ")}\nGuesses remaining: #{6-@guessed.length}\nGuess a letter OR type 'save' to save your progress: "
      guess = gets.chomp
    
      if guess.downcase == "save"
        Dir.mkdir("temp") if !Dir.exist?("temp")
        File.open("temp/save.yaml", "w") do |file|
          file.puts YAML::dump(self)
        end
        puts "Game saved"
      elsif guess.length == 1
        make_guess(guess)
      else
        puts "\n\n\nInvalid guess length"
      end
    end
    
    if @guessed.length == 6
      puts "YOU LOSE"
    else
      puts "#{@display}\n\nYOU WIN"
    end
  end

  def to_s
    "Word: #{@rand_word}\nGuessed words: #{@guessed}\nDisplay: #{@display}"
  end
end

puts "Would you like to \n\t1. [load] a save\n\t2. start a [new] game"
response = gets.chomp
game = nil
if response == "load"
  if File.exist?("temp/save.yaml")
    File.open("temp/save.yaml", "r") do |object|
      game = YAML::load(object)
    end
  else
    puts "No save found, Starting new game"
    game = Hangman.new
  end
else
  puts "Not sure what that means... Starting a new game"
  game = Hangman.new
end

if game != nil
  game.play
end