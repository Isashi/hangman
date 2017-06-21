require "yaml"

class Hangman

	def initialize
		dictionary = Array.new
		dictionary = File.readlines($file)
		dictionary.each_with_index do |value, index|
  		dictionary[index] = dictionary[index].gsub(/\s+/, "").downcase
		end
		dictionary = dictionary.reject!{|value| value.length < 6 || value.length > 12}
		$secret_word = dictionary.sample
		puts $secret_word
		$turn = 10
		$guessed = Array.new(0)
		$gameover = false
	end

	def title
		system "clear"
		puts %q{Hangman}
		puts ""
	end

	def start
		title
		puts "Menu:
		1) play
		2) change dictionary
		3) load
		4) quit	
		"
		puts "Choice:"
		choice = gets.chomp.downcase
		case choice
			when "1","1)","play" then newgame
			when "2","2)","change" then changedic
			when "3","3)","load" then load_game
			when "4","4)","quit" then quit	
			else puts "Choice not accepted"; gets; start
		end
	end

	def quit
		exit
	end

	def changedic
			puts "Dictionaries:
		1) Animals
		2) Body parts
		3) Cities
		4) Countries
		5) Random Words (default)
		"
		puts "Choice:"
		choice = gets.chomp.downcase
		case choice
			when "1","1)","animals" then $file = 'animals.txt' 
			when "2","2)","body parts" then $file = 'body.txt'
			when "3","3)","cities" then $file = 'cities.txt'
			when "4","4)","countries" then $file = 'countries.txt'
			when "5","5)","random words" then $file = '5desk.txt'	
			else puts "Choice not accepted"; gets; changedic
		end
		game = Hangman.new
		game.start
	end

	def secretword
		$remainingletters = $secret_word.length
  	$secret_word.length.times do |i|
    	if $guessed.include? $secret_word[i] then
      	print "#{$secret_word[i]} " 
      	$remainingletters -= 1
 		 	  else
    	  print "_ "
    	end
  	end
  	puts
	end

	def checkword
		$remainingletters = $secret_word.length
  	$secret_word.length.times do |i|
    	if $guessed.include? $secret_word[i] then
      	$remainingletters -= 1
    	end
  	end
	end

	def play_again?
		puts "Another game? y/n"
		game = Hangman.new
		choice = gets.chomp.downcase
		case choice
			when "n", "no" then game.start
			else game.newgame
		end
	end

	def newgame
		loop do 
			figure
			secretword
			until $gameover
  		puts "#{$turn} turn left"
  		puts "Insert letter:"
  		check_input
  		checkword
  		if $secret_word.include? $guess then
 				puts "Correct!" else
 				$turn -= 1
 			end
  		if $remainingletters == 0 then
  			figure
  			secretword
  			win
  			$gameover = true elsif
  			$turn > 0 then
  			newgame else
  			figure
  			puts "Game over! The secret word was ""#{$secret_word}""!"
  		end
			play_again?
			end
		end
	end

	def check_input
    $guess = gets.chomp.downcase
    if $guess == "save"
      save_game
    elsif $guess == "quit"
      quit
    elsif $guess == "menu"
      start
    elsif $guess =~ /[a-z]/ && $guess.length == 1
      $guessed << $guess
    else
      puts "Invalid input. Try again:"
      check_input
    end
	end

  def save_game
    data = { "secret_word"      => $secret_word,
             "guessed"          => $guessed,
             "turn"             => $turn}

    yaml = YAML.dump(data)

    File.open("saved_game.yaml", "w") { |file| file.puts yaml }

    start
	end

	def load_game
    yaml = YAML.safe_load(File.open("saved_game.yaml"))

    $secret_word      = yaml["secret_word"]
    $guessed          = yaml["guessed"]
    $turn             = yaml["turn"]
    
    newgame
  end

  def win
  	system "clear"
  	puts %q{            .---.
            |#__|
           =;===;=
           / - - \
          ( _'.'_ )
         .-`-'^'-`-.
        |   `>o<'   |
        /     :     \
       /  /\  :  /\  \
     .-'-/ / .-. \ \-'-.
      |_/ /-'   '-\ \_|
         /|   |   |\
        (_|  /^\  |_)
          |  | |  |
          |  | |  |
        '==='= ='==='
}
    puts "Congratulations! You win! The secret word was #{$secret_word}"
  end

	def figure
		system "clear"
		case $turn
			when 10 then puts %q{
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
}
			when 9 then puts %q{
  
| 
| |  
| | 
| | 
| | 
| |  
| |  
| |  
| |   
| |   
| |   
| |   
| |  
| |  
| |  
| |  
| |  
}
			when 8 then puts %q{
 ___________.._______
| .__________))______|
| | 
| | 
| | 
| | 
| |          
| |          
| |         
| |        
| |        
| |       
| |     
| |           
| |         
| |        
| |         
| |        
}
			when 7 then puts %q{
 ___________.._______
| .__________))______|
| | / /      
| |/ /        
| | /        
| |/          
| |          
| |          
| |         
| |         
| |        
| |     
| |      
| |           
| |          
| |           
| |           
| |          
}
			when 6 then puts %q{
 ___________.._______
| .__________))______|
| | / /      ||
| |/ /       ||
| | /        || 
| |/         ||
| |          ||   
| |           
| |        
| |        
| |        
| |       
| |     
| |          
| |         
| |        
| |         
| |        
}
			when 5 then puts %q{
 ___________.._______
| .__________))______|
| | / /      ||
| |/ /       ||
| | /        ||.-''.
| |/         |/  _  \
| |          ||  `/,|
| |          (\\\\`_.'
| |          -`--'
| |         
| |       
| |       
| |    
| |          
| |          
| |          
| |           
| |          
}
			when 4 then puts %q{
 ___________.._______
| .__________))______|
| | / /      ||
| |/ /       ||
| | /        ||.-''.
| |/         |/  _  \
| |          ||  `/,|
| |          (\\\\`_.'
| |         .-`--'.
| |           . .  
| |          |   |  
| |          | . |   
| |          |   |    
| |           
| |          
| |          
| |          
| |         
}
			when 3 then puts %q{
 ___________.._______
| .__________))______|
| | / /      ||
| |/ /       ||
| | /        ||.-''.
| |/         |/  _  \
| |          ||  `/,|
| |          (\\\\`_.'
| |         .-`--'.
| |        /Y . .  
| |       // |   |  
| |      //  | . |   
| |     ')   |   | 
| |          
| |           
| |           
| |          
| |          
}
			when 2 then puts %q{
 ___________.._______
| .__________))______|
| | / /      ||
| |/ /       ||
| | /        ||.-''.
| |/         |/  _  \
| |          ||  `/,|
| |          (\\\\`_.'
| |         .-`--'.
| |        /Y . . Y\
| |       // |   | \\\\
| |      //  | . |  \\\\
| |     ')   |   |   (`
| |           
| |           
| |           
| |           
| |          
}
			when 1 then puts %q{
 ___________.._______
| .__________))______|
| | / /      ||
| |/ /       ||
| | /        ||.-''.
| |/         |/  _  \
| |          ||  `/,|
| |          (\\\\`_.'
| |         .-`--'.
| |        /Y . . Y\
| |       // |   | \\\\
| |      //  | . |  \\\\
| |     ')   |   |   (`
| |          ||  
| |          ||  
| |          ||  
| |          ||  
| |         / |  
}
			when 0 then puts %q{
 ___________.._______
| .__________))______|
| | / /      ||
| |/ /       ||
| | /        ||.-''.
| |/         |/  _  \
| |          ||  `/,|
| |          (\\\\`_.'
| |         .-`--'.
| |        /Y . . Y\
| |       // |   | \\\\
| |      //  | . |  \\\\
| |     ')   |   |   (`
| |          ||'||
| |          || ||
| |          || ||
| |          || ||
| |         / | | \
}
		end
	end

end

$file = '5desk.txt'
game = Hangman.new
game.start
