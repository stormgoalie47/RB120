require 'yaml'
MESSAGES = YAML.load_file 'tic_tac_toe_messages.yml'

module Displayable
  private

  YES_NO = %w(y yes n no)

  def clear
    system "clear"
  end

  def no_joining_word(joining_word)
    joining_word.nil? || joining_word.strip.empty?
  end

  def list_array(array, last_comma = ',', joining_word = nil)
    return array.first if array.length <= 1
    string = array[0..-2].join(', ')
    string << if no_joining_word(joining_word)
                "#{last_comma} #{joining_word} #{array[-1]}"
              else
                "#{last_comma} #{array[-1]}"
              end
  end

  def prompt(message)
    message = determine_message(message)
    message.each_line { |line| puts ">>>>  #{line.strip}" }
    puts '-' * (message.lines.max.length + 8)
  end

  def determine_message(message)
    MESSAGES.include?(message) ? MESSAGES[message] : message
  end

  def prompt_input(message)
    puts
    message = determine_message(message)
    print ">> #{message}  "
  end

  def return_to_continue
    puts
    prompt 'return_to_continue'
    gets
    clear
  end
end

class Board
  include Displayable

  attr_reader :winner

  NUMBER_TO_WIN = 3

  def initialize
    set_dimension
    set_number_to_win

    determine_winning_rows!

    reset
  end

  def []=(number, mark)
    squares[number] = mark
  end

  def [](number)
    squares[number]
  end

  def draw
    1.upto(dimension) do |iteration|
      start_index = iteration * dimension - (dimension - 1)
      draw_empty_lines
      draw_marks(start_index)
      draw_empty_lines
      draw_separator_line unless iteration == dimension
    end
  end

  def full?
    unmarked_numbers.empty?
  end

  def reset
    self.winner = nil

    self.squares = {}
    (1..(dimension**2)).each { |square| squares[square] = Square.new }
  end

  def best_move(mark, opponent_mark)
    winning_move = square_at_risk(mark)
    return winning_move if winning_move

    defensive_move = square_at_risk(opponent_mark)
    return defensive_move if defensive_move
  end

  def unmarked_numbers
    squares.select { |_, square| square.to_s.strip.empty? }.keys
  end

  def winner?
    winning_marker
  end

  private

  attr_accessor :squares, :dimension, :number_shifts,
                :number_to_win, :winning_rows
  attr_writer :winner

  def empty_square(row)
    row.each { |number| return number if squares[number].marker.strip.empty? }
  end

  def entire_row_same_marker?(row, mark)
    row.all? { |next_mark| mark == squares[next_mark].marker }
  end

  def winning_marker
    winning_rows.any? do |row|
      mark = squares[row.first].marker
      next if mark.strip.empty?
      self.winner = mark if entire_row_same_marker?(row, mark)
    end
  end

  def set_dimension
    dimension = nil
    loop do
      prompt_input 'dimension'
      dimension = gets.chomp
      break if valid_dimension?(dimension)
      prompt_input 'incorrect_dimension'
    end
    self.dimension = dimension.to_i
  end

  def set_number_to_win
    number_to_win = nil
    loop do
      prompt_input 'number_to_win'
      number_to_win = gets.chomp
      break if valid_number_to_win?(number_to_win)
      prompt_input 'incorrect_number_to_win'
    end
    self.number_to_win = number_to_win.to_i
  end

  def valid_number_to_win?(string)
    string.to_i.to_s == string && string.to_i >= 2 && string.to_i <= dimension
  end

  def valid_dimension?(string)
    string.to_i.to_s == string && string.to_i >= 3
  end

  def square_at_risk(mark)
    square = nil
    winning_rows.each do |row|
      marks = row.map { |number| @squares[number].marker }
      if marks.count(mark) == number_to_win - 1 && marks.count(' ') == 1
        square = empty_square(row)
        break
      end
    end
    square
  end

  def draw_empty_lines
    (dimension - 1).times { print "       |" }
    puts
    (dimension - 1).times { print "       |" }
    puts
  end

  def draw_separator_line
    (dimension - 1).times { print "-------+" }
    print "-------\n"
  end

  def draw_marks(start_index)
    (dimension - 1).times do |shift|
      print "   #{squares[start_index + shift].marker}   |"
    end
    print "   #{squares[start_index + (dimension - 1)].marker}"
    puts
  end

  def determine_winning_rows!
    self.winning_rows = []
    self.number_shifts = dimension - number_to_win + 1

    number_shifts.times do |row|
      rows!(row)
      columns!(row)
      forward_diagonals!(row)
      reverse_diagonals!(row)
    end
  end

  def rows!(shift)
    dimension.times do |iteration|
      row = []
      left_num = iteration * dimension + shift
      1.upto(number_to_win) { |num_to_right| row << left_num + num_to_right }
      winning_rows << row
    end
  end

  def columns!(shift)
    (1..dimension).each do |top_number|
      row = []
      top_number += shift * dimension
      number_to_win.times do |down_rows|
        row << top_number + (down_rows * dimension)
      end
      winning_rows << row
    end
  end

  def reverse_diagonals!(shift)
    number_shifts.times do |column|
      start_num = dimension - column + shift * dimension
      squares = []
      number_to_win.times do |multiplier|
        squares << start_num + (multiplier * (dimension - 1))
      end
      winning_rows << squares.flatten
    end
  end

  def forward_diagonals!(shift)
    (1..number_shifts).each do |column|
      start_num = column + (shift * dimension)
      squares = []
      number_to_win.times do |multiplier|
        squares << start_num + (multiplier * (dimension + 1))
      end
      winning_rows << squares.flatten
    end
  end
end

class Square
  DEFAULT_MARKER = ' '

  attr_accessor :marker

  def initialize
    @marker = DEFAULT_MARKER
  end

  def to_s
    marker
  end
end

class Player
  include Displayable
  attr_accessor :score, :match_wins
  attr_reader :name, :mark

  def initialize
    set_name
    @score = 0
    @match_wins = 0
  end

  private

  attr_writer :mark, :name
end

class Human < Player
  def initialize
    super
    set_mark
  end

  private

  def set_name
    name = nil
    loop do
      prompt_input 'player_name'
      name = gets.chomp
      break unless name.strip.empty?
      prompt_input 'incorrect_name'
    end
    self.name = name.split.map(&:strip).map(&:capitalize).join(' ')
  end

  def set_mark
    mark = nil
    loop do
      prompt_input 'player_mark'
      mark = gets.chomp
      break if mark.strip.length == 1
      prompt_input 'incorrect_mark'
    end
    self.mark = mark.capitalize
  end
end

class Computer < Player
  NAMES = %w(Tic Tac Toe)

  def initialize(human_mark)
    super()
    computer_mark(human_mark)
  end

  private

  def set_name
    self.name = NAMES.sample
  end

  def computer_mark(human_mark)
    self.mark = human_mark == "O" ? "X" : "O"
  end
end

class TicTacToeGame
  include Displayable

  WIN_MATCH = 5

  def initialize
    display_welcome_message
    @human = Human.new
    @computer = Computer.new(human.mark)
    @human_turn = true
    @board = Board.new
  end

  def play
    loop do
      play_match
      display_winner

      display_match_score
      break unless play_again?
      reset_match
    end
    display_goodbye_message
  end

  private

  attr_accessor :board, :human, :computer, :human_turn

  def play_game
    display_board
    loop do
      next_move
      break if board.winner? || board.full?
      clear_screen_and_display_board
    end
    update_score
  end

  def play_match
    loop do
      play_game
      display_board_and_winner
      display_score
      break if match_winner?
      reset
    end
  end

  def match_winner?
    human.score >= WIN_MATCH || computer.score >= WIN_MATCH
  end

  def update_matches(player)
    player.match_wins += 1 if match_winner?
  end

  def update_score
    if board.winner == human.mark
      human.score += 1
      update_matches(human)
    elsif board.winner == computer.mark
      computer.score += 1
      update_matches(computer)
    end
  end

  def next_move
    human_turn? ? human_move : computer_move
    self.human_turn = !human_turn
  end

  def reset
    board.reset
    self.human_turn = true
  end

  def reset_match
    reset
    human.score = 0
    computer.score = 0
  end

  def display_board
    puts "You are: #{human.mark}"
    puts "The computer is: #{computer.mark}"
    puts
    board.draw
    puts
  end

  def display_score
    prompt "The current score is:"
    puts "#{human.name}: #{human.score}"
    puts "#{computer.name}: #{computer.score}"
    return_to_continue
  end

  def display_match_score
    prompt "Matches won:"
    puts "#{human.name}: #{human.match_wins}"
    puts "#{computer.name}: #{computer.match_wins}"
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  def display_unmarked_numbers
    prompt "Choose from: #{list_array(board.unmarked_numbers, ',', 'or')}"
  end

  def human_turn?
    human_turn
  end

  def human_move
    square_number = nil
    loop do
      prompt 'human_move'
      display_unmarked_numbers
      square_number = gets.chomp.to_i
      break if board.unmarked_numbers.include? square_number
      clear_screen_and_display_board
      prompt 'choose_open_square'
    end
    board[square_number].marker = human.mark
  end

  def choose_random_open_square
    board.unmarked_numbers.sample
  end

  def computer_move
    best_move = board.best_move(computer.mark, human.mark)
    square_number = best_move || choose_random_open_square
    board[square_number].marker = computer.mark
  end

  def display_welcome_message
    clear
    prompt 'welcome'
    puts
  end

  def display_goodbye_message
    clear
    prompt 'goodbye'
    puts
  end

  def play_again?
    answer = nil
    loop do
      puts
      prompt 'play_again?'
      answer = gets.chomp.downcase
      break if YES_NO.include?(answer)
      clear
      prompt 'yes_or_no'
    end
    clear
    answer[0] == 'y'
  end

  def display_winner
    prompt case board.winner
           when human.mark then "#{human.name} won!"
           when computer.mark then "#{computer.name} won..."
           else "It's a tie..."
           end
  end

  def display_board_and_winner
    clear_screen_and_display_board
    display_winner
  end
end

TicTacToeGame.new.play
