require "pry"

class Deck
  SUITS = %w(Clubs Diamonds Hearts Spades)
  FACES = %w(2 3 4 5 6 7 8 9 10 Jack Queen King Ace)

  attr_accessor :cards

  def initialize
    new_cards
    cards.shuffle!
  end

  def new_cards
    self.cards = []
    SUITS.each do |suit|
      FACES.each do |face|
        cards << Card.new(suit, face)
      end
    end
  end

  def hit!
    cards.pop
  end
end

class Card
  attr_accessor :suit, :face, :value

  def initialize(suit, face)
    @suit = suit
    @face = face
    @value = determine_value
  end

  def ace?
    face == 'Ace'
  end

  private

  def determine_value
    case face
    when 'Jack' then [10]
    when 'Queen' then [10]
    when 'King' then [10]
    when 'Ace' then [1, 11]
    else [face.to_i]
    end
  end
end

class Hand
  attr_accessor :cards, :value

  GOAL = 21

  def initialize
    reset
  end

  def determine_value
    high_value = high_ace_value
    @value = high_value <= GOAL ? high_value : low_ace_value
  end

  def hidden_to_s
    "\t#{cards.first.face} of #{cards.first.suit}\n\tUnknown"
  end

  def high_ace_value
    high_ace = true
    score = 0
    cards.each do |card|
      if card.ace? && high_ace
        high_ace = false
        score += 10
      end
      score += card.value.first
    end
    score
  end

  def bust?
    value > GOAL
  end

  def low_ace_value
    sum = 0
    cards.each { |card| sum += card.value.first }
    sum
  end

  def <<(card)
    cards << card
    determine_value
  end

  def reset
    self.cards = []
    self.value = 0
  end

  def to_s
    string = ''
    cards.each { |card| string << "\t#{card.face} of #{card.suit}\n" }
    string
  end

  def >(other_hand)
    value > other_hand.value
  end

  def <(other_hand)
    value < other_hand.value
  end
end

class Player
  attr_accessor :hand, :score, :name

  def initialize
    @score = 0
    @hand = Hand.new
    determine_name
  end

  def prompt(message)
    puts "\n>>>  " + message
    puts
  end
end

class Dealer < Player
  def determine_name
    self.name = %w(Don Ron Juan).sample
  end
end

class Human < Player
  def determine_name
    name = nil
    prompt "What is your name?"
    loop do
      name = gets.chomp.strip
      break unless name.empty?
      prompt "Sorry. Please enter a name."
    end
    self.name = name
  end
end

class TwentyOneGame
  def initialize
    display_welcome_message
    @dealer = Dealer.new
    @human = Human.new
  end

  def play
    loop do
      game
      break unless play_again?
    end

    display_overall_results
    display_goodbye_message
  end

  private

  attr_accessor :deck, :human, :dealer, :winner

  def game
    reset_table
    human_turn
    dealer_turn
    determine_winner
    update_score
    display_game_results
    puts "Dealer: #{dealer.hand.value}"
    puts "Human: #{human.hand.value}"
  end

  def clear
    system "clear"
  end

  def deal_cards
    2.times do
      human_hit!
      dealer_hit!
    end
  end

  def dealer_hit!
    dealer.hand << deck.hit!
  end

  def dealer_turn
    loop do
      break if dealer.hand.value >= 17
      dealer_hit!
    end
  end

  def display_all_cards
    prompt "#{dealer.name}(dealer) has:"
    puts dealer.hand.to_s

    prompt "#{human.name} has:"
    puts human.hand.to_s
  end

  def determine_winner
    human_hand = human.hand
    dealer_hand = dealer.hand
    self.winner = if human_hand.bust?
                    dealer
                  elsif dealer_hand.bust?
                    human
                  else best_hand
                  end
  end

  def best_hand
    if human.hand > dealer.hand
      human
    elsif human.hand < dealer.hand
      dealer
    end
  end

  def update_score
    winner.score += 1
  end

  def display_game_results
    display_all_cards

    case winner
    when dealer then prompt "#{dealer.name}(dealer) won..."
    when human then prompt "#{human.name} won!"
    else prompt "It's a tie..."
    end
  end

  def display_goodbye_message
    prompt "Thanks for playing!"
  end

  def display_overall_results
    clear
    prompt "Total wins: "
    puts "#{human.name}: #{human.score}"
    puts "#{dealer.name}(dealer): #{dealer.score}"
  end

  def display_welcome_message
    clear
    prompt "Welcome to 21!"
  end

  def display_with_hidden_card
    clear
    prompt "#{dealer.name}(dealer) has:"
    puts dealer.hand.hidden_to_s

    prompt "You have:"
    puts human.hand.to_s
  end

  def human_hit!
    human.hand << deck.hit!
  end

  def human_turn
    loop do
      display_with_hidden_card
      break if human.hand.bust? || stay?
      human_hit!
    end
    clear
  end

  def new_deck
    self.deck = Deck.new
  end

  def prompt(message)
    puts "\n>>>  " + message
    puts
  end

  def play_again?
    answer = nil
    loop do
      prompt "Would you like to play again? y/n"
      answer = gets.chomp.downcase
      break if %w(y yes no n).include? answer
      prompt "Sorry, please enter yes(y) or no(n)."
    end
    answer[0] == 'y'
  end

  def reset_table
    clear
    new_deck
    dealer.hand.reset
    human.hand.reset
    deal_cards
    self.winner = nil
  end

  def stay?
    answer = nil
    loop do
      prompt "Would you like to hit or stay?"
      answer = gets.chomp.downcase
      break if %w(h hit s stay).include? answer
      prompt "Sorry. You must enter hit(h) or stay(s)"
    end
    clear
    %w(s stay).include? answer
  end
end

TwentyOneGame.new.play
