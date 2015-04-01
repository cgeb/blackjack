class Card
  attr_reader :face_value, :suit

  def initialize(face_value, suit)
    @face_value = face_value
    @suit = suit
  end

  def to_s
    "The #{face_value} of #{suit}"
  end
end

class Deck
  attr_accessor :game_decks

  def initialize(number_of_decks)
    @game_decks = []
    [2, 3, 4, 5, 6, 7, 8, 9, 10, 'J', 'Q', 'K', 'A'].each do |face_value|
      ['hearts', 'clubs', 'diamonds', 'spades'].each do |suit|
        number_of_decks.times {@game_decks << Card.new(face_value, suit)}
      end
    end
    game_decks.shuffle!
  end

  def deal_card
    game_decks.pop
  end
end

module Hand
  def total
    total = 0
    cards.each do |card|
      if card.face_value == 'A'
        total += 11
      elsif %w(J Q K).include?(card.face_value)
        total += 10
      else
        total += card.face_value
      end
    end

    cards.each do |card|
      if card.face_value == 'A' && total > Game::BLACKJACK_AMOUNT
        total -= 10
      end
    end
    total
  end

  def show_hand
    puts "#{name}'s cards:"
    cards.each do |card|
      puts "=> #{card}"
    end
    puts "=> Total is #{total}"
  end

  def bust
    total > Game::BLACKJACK_AMOUNT
  end

  def blackjack
    total == Game::BLACKJACK_AMOUNT && cards.length == 2
  end

  def add_card(new_card)
    cards << new_card
  end
end

class Player
  include Hand
  attr_accessor :name, :cards

  def initialize(name)
    @name = name
    @cards = []
  end

  
end

class Dealer
  include Hand
  attr_accessor :name, :cards

  def initialize
    @name = "Computer"
    @cards = []
  end

  def show_one_card
    puts "#{name}'s cards:"
    puts "=> #{cards[0]}"
  end

  
end

class Game
  BLACKJACK_AMOUNT = 21
  DEALER_HIT_MIN = 17
  attr_accessor :deck, :player, :dealer

  def initialize
    @deck = Deck.new(1)
    puts "What is your name?"
    name = gets.chomp
    @player = Player.new(name)
    @dealer = Dealer.new
  end

  def deal_cards
    2.times do
      player.add_card(deck.deal_card)
      dealer.add_card(deck.deal_card)
    end
  end

  def player_turn
    until player.bust
      if player.total == BLACKJACK_AMOUNT
        puts "You have 21!" 
        break
      end
      puts "Would you like to hit or stay?"
      answer = gets.chomp.downcase
      if %w(h hit).include?(answer)
        player.add_card(deck.deal_card)
        puts "#{player.name} is dealt #{player.cards[-1]}"
        player.show_hand
      elsif %w(s stay).include?(answer)
        break
      else
        puts "I don't understand that."
      end
    end
    puts "You busted!" if player.bust      
  end

  def dealer_turn
    dealer.show_hand
    sleep 1
    while dealer.total < DEALER_HIT_MIN && !dealer.bust
      dealer.add_card(deck.deal_card)
      puts "#{dealer.name} is dealt #{dealer.cards[-1]}"
      dealer.show_hand
      sleep 1
    end
    puts "#{dealer.name} busted! You win!" if dealer.bust
  end

  def new_game
    puts "Would you like to play again?"
    answer = gets.chomp.downcase
    if %w(y yes).include?(answer)
      player.cards = []
      dealer.cards = []
      play
    else
      exit
    end
  end

  def check_for_blackjack
    if player.blackjack
      puts "You have blackjack!"
      sleep 1
      dealer.show_hand
      if dealer.blackjack
        puts "#{dealer.name} also has blackjack! It's a tie!"
      else
        puts "You win!"
      end
    end
  end

  def compare_hands
    if player.total > dealer.total
      puts "#{player.name} wins!"
    elsif dealer.total > player.total
      puts "#{dealer.name} wins!"
    else
      puts "It's a tie!"
    end
  end

  def play
    deal_cards
    player.show_hand
    check_for_blackjack
    new_game if player.blackjack
    dealer.show_one_card
    player_turn
    sleep 1
    dealer_turn unless player.bust
    compare_hands unless player.bust || dealer.bust
    new_game
  end
end

Game.new.play


