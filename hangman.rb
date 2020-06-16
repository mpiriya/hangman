def get_random_word 
  words = Array.new

  File.open("5desk.txt").readlines.each do |word|
    words.push(word.chomp)
  end

  rand_word = words[Random.rand(words.length)]
end

def make_guess(guess, rand_word, display, guessed)
  used = false
  for i in 0..rand_word.length-1
    if rand_word[i,1].downcase == guess.downcase
      display[i*2] = guess
      used = true
    end
  end
  if !used && guessed.index(guess) == nil
    guessed.push(guess)
  end 
end

rand_word = get_random_word
guessed = []
display = "_ "*rand_word.length
# puts rand_word

until guessed.length == 6 || display.index("_") == nil do
  puts "\n\n\n\n\n#{display}\nLetters guessed incorrectly: #{guessed.join(" ")}\nGuesses remaining: #{6-guessed.length}\nGuess a letter: "
  
  make_guess(gets.chomp, rand_word, display, guessed)
end

if guessed.length == 6
  puts "YOU LOSE"
else
  puts "#{display}\n\nYOU WIN"
end