class Player
  attr_accessor :move, :name, :score, :match_wins, :moves_count

  def initialize
    set_name
    @score = 0
    @match_wins = 0
    @moves_count = { 'rock' => 0, 'paper' => 0, 'scissors' => 0,
                     'lizard' => 0, 'spock' => 0 }
  end
end

class Human < Player
  def set_name
    name = nil
    loop do
      puts "What's your name?\n\n"
      name = gets.chomp
      break unless name.empty?
      puts "Sorry, must enter a value."
    end
    self.name = name
  end

  def user_choice
    loop do
      system "clear"
      puts "#{name}, please choose rock, paper, scissors, spock or lizard:\n\n"
      choice = gets.chomp
      return choice if Move::VALUES.include? choice
      puts "Sorry, invalid choice. Try again."
    end
  end

  def choose
    choice = user_choice
    @moves_count[choice] += 1
    self.move = Move.new(choice)
    system "clear"
  end
end

class Computer < Player
  def set_name
    self.name = ['Mac Mini', 'MacBook Pro', 'HP', 'Sony'].sample
  end

  def choose
    self.move = Move.new(Move::VALUES.sample)
    @moves_count[move.to_s] += 1
  end
end

class Move
  VALUES = %w(rock paper scissors spock lizard)
  def initialize(value)
    @value = value
  end

  def scissors?
    @value == 'scissors'
  end

  def paper?
    @value == 'paper'
  end

  def rock?
    @value == 'rock'
  end

  def spock?
    @value == 'spock'
  end

  def lizard?
    @value == 'lizard'
  end

  def lose_rock?(other_move)
    other_move.scissors? || other_move.lizard?
  end

  def lose_scissors?(other_move)
    other_move.paper? || other_move.lizard?
  end

  def lose_paper?(other_move)
    other_move.rock? || other_move.spock?
  end

  def lose_spock?(other_move)
    other_move.scissors? || other_move.rock?
  end

  def lose_lizard?(other_move)
    other_move.spock? || other_move.paper?
  end

  def >(other_move)
    (rock? && lose_rock?(other_move)) ||
      (scissors? && lose_scissors?(other_move)) ||
      (paper? && lose_paper?(other_move)) ||
      (spock? && lose_spock?(other_move)) ||
      (lizard? && lose_lizard?(other_move))
  end

  def <(other_move)
    (rock? && !lose_rock?(other_move)) ||
      (scissors? && !lose_scissors?(other_move)) ||
      (paper? && !lose_paper?(other_move)) ||
      (spock? && !lose_spock?(other_move)) ||
      (lizard? && !lose_lizard?(other_move))
  end

  def to_s
    @value
  end
end

class RPSGame
  attr_accessor :human, :computer

  WIN_MATCH = 3

  def initialize
    system "clear"
    display_welcome_message
    @human = Human.new
    @computer = Computer.new
  end

  def display_welcome_message
    puts "Welcome to Rock, Paper, Scissors!"
    puts "\nWhoever gets to 3 wins first wins the match!"
    puts "---------------------------------\n\n"
    return_continue
  end

  def display_goodbye_message
    puts "Thanks for playing Rock, Paper, Scissors, Lizard, Spock. Good bye!"
  end

  def display_moves
    puts "#{human.name} chose: #{human.move}"
    puts "#{computer.name} chose: #{computer.move}\n\n"
  end

  def display_winner
    if human.move > computer.move
      puts "#{human.name} won!\n\n"
    elsif human.move < computer.move
      puts "#{computer.name} won...\n\n"
    else
      puts "It's a tie...\n\n"
    end
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp
      break if ['y', 'n'].include? answer.downcase
      puts "Sorry, must be y or n."
    end

    system "clear"
    answer == 'y'
  end

  def display_score
    puts "#{human.name} score: #{human.score}"
    puts "#{computer.name} score: #{computer.score}\n\n"
  end

  def update_scores
    if human.move > computer.move
      human.score += 1
    elsif human.move < computer.move
      computer.score += 1
    end
  end

  def match_winner?
    human.score >= WIN_MATCH || computer.score >= WIN_MATCH
  end

  def return_continue
    puts "Press return to continue."
    gets
    system "clear"
  end

  def score_reset
    human.score = 0
    computer.score = 0
  end

  def play_match
    human.choose
    computer.choose
    update_scores
    display_moves
    display_winner
    display_score
    return_continue
  end

  def match_wins_update
    human.score >= WIN_MATCH ? human.match_wins += 1 : computer.match_wins += 1
  end

  def display_match_wins
    puts "#{human.name} has won #{human.match_wins} matches."
    puts "#{computer.name} has won #{computer.match_wins} matches.\n\n"
  end

  def display_match_winner
    winner = human.score >= WIN_MATCH ? human.name : computer.name
    puts "#{winner} won the match to #{WIN_MATCH}\n\n"
  end

  def display_move_history
    puts "\n#{human.name} made the following moves:"
    puts "------------------------------------------------"
    total_moves = human.moves_count.values.sum.to_f
    human.moves_count.each do |move, count|
      puts "#{move}: #{(count / total_moves * 100).round}%"
    end

    puts "\n#{computer.name} made the following moves:"
    puts "------------------------------------------------"
    computer.moves_count.each do |move, count|
      puts "#{move}: #{(count / total_moves * 100).round}%"
    end
  end

  def play
    loop do
      loop do
        play_match
        break if match_winner?
      end
      match_wins_update
      display_match_winner
      display_match_wins
      break unless play_again?
      score_reset
    end
    display_goodbye_message
    display_move_history
  end
end

RPSGame.new.play
