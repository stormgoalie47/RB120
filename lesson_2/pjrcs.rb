require 'yaml'
MESSAGES = YAML.load_file('pjrcs_messages.yml')

def prompt_tight(output)
  output = ">>>  " + output.to_s
  puts output
  puts "-" * (output.to_s.lines.max.length + 2)
end

def prompt_border(output)
  puts "+" + ("-" * output.to_s.lines.max.length) + "+"
  puts "|#{output}|"
  puts "+" + ("-" * output.to_s.lines.max.length) + "+"
  puts
end

def prompt(output)
  prompt_tight(output)
  puts
end

class Player
  attr_accessor :name, :move, :move_history, :score, :match_wins

  def initialize
    set_name
    @score = 0
    @match_wins = 0
    @move_history = { python: 0,
                      javascript: 0,
                      ruby: 0,
                      cplusplus: 0,
                      swift: 0 }
  end

  def track_move
    move_history[move_to_sym] += 1
  end

  def move_to_sym
    move.class.to_s.downcase.to_sym
  end
end

class Human < Player
  MOVES = ['p', 'python',
           'j', 'javascript',
           'r', 'ruby',
           'c', 'c++',
           's', 'swift']

  def set_name
    name = nil
    loop do
      prompt MESSAGES['get_name']
      name = gets.chomp.split.each(&:capitalize!).join(' ')

      system "clear"
      break unless name.strip.empty?

      prompt MESSAGES['no_name']
    end

    self.name = name
  end

  def choose
    choice = nil
    loop do
      prompt MESSAGES['player_choose']
      choice = gets.chomp.downcase

      system "clear"
      break if MOVES.include? choice

      prompt MESSAGES['wrong_choice']
    end

    self.move = choice_object(choice)
    track_move
  end

  def choice_object(choice)
    case choice[0]
    when 'p' then Python.new
    when 'j' then JavaScript.new
    when 'r' then Ruby.new
    when 'c' then CPlusPlus.new
    when 's' then Swift.new
    end
  end
end

module SwiftOnly
  def choose
    self.move = Swift.new
    track_move
  end
end

module ChooseAny
  def choose
    self.move = [Python.new,
                 JavaScript.new,
                 Ruby.new,
                 CPlusPlus.new,
                 Swift.new].sample
    track_move
  end
end

class Computer < Player
  def set_name
    self.name = ['Steve Jobs',
                 'Bjarne Stroustrup',
                 'Dennis Ritchie',
                 'Yukihiro Matsumoto'].sample
  end

  def choose(human_move)
    case name
    when 'Steve Jobs'         then choose_swift
    when 'Bjarne Stroustrup'  then choose_not_ruby
    when 'Dennis Ritchie'     then choose_not_yours(human_move)
    else                           choose_any
    end

    track_move
  end

  def choose_swift
    self.move = Swift.new
  end

  def choose_not_ruby
    self.move = [Python.new, JavaScript.new, CPlusPlus.new, Swift.new].sample
  end

  def choose_not_yours(human_move)
    loop do
      self.move = [Python.new,
                   JavaScript.new,
                   Ruby.new,
                   CPlusPlus.new,
                   Swift.new].sample

      break unless move.class == human_move.class
    end
  end

  def choose_any
    self.move = [Python.new,
                 JavaScript.new,
                 Ruby.new,
                 CPlusPlus.new,
                 Swift.new].sample
  end
end

module Moves
  def >(other_move)
    other_move = other_move.class.to_s.downcase.to_sym
    self.class::BEATS.include?(other_move)
  end

  def to_s
    self.class.to_s
  end
end

class Python
  include Moves

  BEATS = [:javascript, :cplusplus]
end

class JavaScript
  include Moves

  BEATS = [:ruby, :swift]
end

class Ruby
  include Moves

  BEATS = [:cplusplus, :python]
end

class CPlusPlus
  include Moves

  BEATS = [:swift, :javascript]
end

class Swift
  include Moves

  BEATS = [:python, :ruby]
end

module Display
  def return_continue
    puts
    prompt MESSAGES['return_continue']
    gets
    system "clear"
  end

  def return_continue_history
    answer = nil
    loop do
      prompt MESSAGES['return_continue_hx']
      answer = gets.chomp

      system "clear"
      return if answer.empty?
      break if ['h', 'history'].include?(answer)
    end

    display_move_history
    return_continue
  end

  def display_welcome_message
    system "clear"
    prompt MESSAGES['welcome']
    puts MESSAGES['detail']

    prompt "Rules"
    puts MESSAGES['rules']

    prompt MESSAGES['computer_info']
    puts MESSAGES['personalities']

    return_continue
  end

  def display_goodbye_message
    system "clear"
    prompt MESSAGES['goodbye']
    display_match_wins
  end

  def display_opponent
    prompt "Your opponent is: #{computer.name}"
    puts MESSAGES[computer.name]
    return_continue
  end

  def choice(person)
    MESSAGES[person.move.to_s.downcase]
  end

  def display_choices
    prompt_tight "Choices made this round:"
    puts "#{human.name}: " + choice(human)
    puts "#{computer.name}: " + choice(computer)
    puts
  end

  def display_score
    prompt_tight "Games won (playing to #{num_games}):"
    puts "#{human.name}: #{human.score}"
    puts "#{computer.name}: #{computer.score}\n\n\n"
    return_continue_history
  end

  def display_winner
    prompt_border winner ? "#{winner.name} won!" : "It's a tie..."
  end

  def percentage(times)
    (times.to_f / total_games * 100).round
  end

  def display_percentages(person)
    prompt_tight person.name + MESSAGES['moves_made']
    person.move_history.each do |move, times|
      puts "#{MESSAGES[move]}: #{percentage(times)}%"
    end
    puts
  end

  def display_move_history
    display_percentages(human)
    display_percentages(computer)
  end

  def display_match_winner
    prompt_border "#{winner.name} won the match!"
  end

  def display_match_wins
    prompt_tight "Total matches won:"
    puts "#{human.name}: #{human.match_wins}"
    puts "#{computer.name}: #{computer.match_wins}\n\n"
  end
end

module GameFlow
  def games_per_match
    games = nil
    loop do
      prompt human.name + MESSAGES['number_games']
      games = gets.chomp.to_i

      break if games > 0
      prompt MESSAGES['no_number']
    end

    self.num_games = games
  end

  def determine_winner
    self.winner = nil
    self.winner = if human.move > computer.move
                    human
                  elsif computer.move > human.move
                    computer
                  end
  end

  def update_score
    winner.score += 1 if winner
  end

  def match_won?
    winner.score >= num_games unless winner.nil?
  end

  def play_again?
    answer = nil
    loop do
      prompt MESSAGES['play_again']
      answer = gets.chomp.downcase

      system "clear"
      break if %w(y yes n no).include?(answer)

      puts MESSAGES['y_or_n']
    end

    answer[0] == 'y'
  end

  def reset_score
    computer.score = 0
    human.score = 0
  end

  def update_match_wins
    winner.match_wins += 1
  end
end

class PJRCSGame
  include Display
  include GameFlow

  def initialize
    display_welcome_message

    self.human = Human.new
    self.computer = Computer.new
    display_opponent

    games_per_match
    self.total_games = 0

    system "clear"
  end

  def play
    loop do
      match

      break unless play_again?
      reset_score
    end

    display_goodbye_message
    display_move_history
  end

  private

  attr_accessor :num_games, :human, :computer, :winner, :total_games

  def game
    self.total_games += 1

    human.choose
    computer.choose(human.move)

    determine_winner
    update_score

    display_choices
    display_winner
    puts MESSAGES['rules']
    display_score
  end

  def match
    loop do
      game
      break if match_won?
    end

    update_match_wins
    display_match_winner
    display_match_wins
  end
end

PJRCSGame.new.play
