CARD_VALUE_HASH = {"A" => 1, "2" => 2, "3" => 3, "4" => 4, "5" => 5, "6" => 6, "7" => 7, "8" => 8, "9" => 9, "10" => 10, "J" => 10, "Q" => 10, "K" => 10} 
BLACKJACK = 21
DEALER_MUST_STAY = 17
cards = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"]
suits = ["s", "c", "d", "h"]

def create_decks(cards, suits)
  single_deck = cards.product(suits)
  multi_decks = []
  4.times {multi_decks << single_deck}
  multi_decks.flatten!(1).shuffle
end

def print_current_cards(players_cards, dealers_cards)
  puts "Your cards are:\n #{players_cards}\nThe dealer is showing:\n #{dealers_cards[1]}"
end

def print_dealers_cards(dealers_cards)
  puts "The dealers cards are \n #{dealers_cards}"
end

def is_there_an_ace(hand)
  ace = false
  hand.each do |card|
    if card[0] == 'A'
      ace = true
    end
  end
  ace
end

def total_of_cards(hand)
  total = 0
  hand.each do |card|   
    total += CARD_VALUE_HASH[card[0]]
  end
  if total < 12 && is_there_an_ace(hand) == true
    total += 10
  end
  total
end

def check_for_blackjack(hand)
  blackjack = true if (hand.count(2) && total_of_cards(hand) == BLACKJACK)
end
    
game_deck = create_decks(cards, suits)

begin

  players_cards = [game_deck.pop]
  dealers_cards = [game_deck.pop]
  players_cards << game_deck.pop
  dealers_cards << game_deck.pop

  print_current_cards(players_cards, dealers_cards)

  player_stay = false
  player_bust = false
  player_blackjack = check_for_blackjack(players_cards)
  players_cards_total = total_of_cards(players_cards)

  puts "You have Blackjack!" if player_blackjack

  while (!player_stay) && (!player_bust) && (!player_blackjack)
    puts "You have #{players_cards_total}."

    if players_cards_total > BLACKJACK
      puts "You busted!"
      player_bust = true
      break
    elsif players_cards_total == BLACKJACK
      sleep 2
      break
    else
      puts "Would you like to hit or stay?"
      action = gets.chomp.downcase
      if action == 's' || action == 'stay'
        player_stay = true
        break
      elsif action == 'h' || action == 'hit'
        players_cards << game_deck.pop
        puts "\nYou were dealt #{players_cards[-1]}"
        print_current_cards(players_cards, dealers_cards)
      else
        puts "That's not a valid action."
      end
    end
    players_cards_total = total_of_cards(players_cards)
  end

  dealer_stay = false
  dealer_bust = false
  dealer_blackjack = check_for_blackjack(dealers_cards)
  dealers_cards_total = total_of_cards(dealers_cards)

  if !player_bust
    puts "\nThe dealer turns over #{dealers_cards[0]}"
    print_dealers_cards(dealers_cards)
    puts "Dealer has Blackjack!" if dealer_blackjack
  end

  while (!dealer_stay) && (!player_bust) && (!player_blackjack) && (!dealer_blackjack)

    puts "The dealer has #{dealers_cards_total}."

    if dealers_cards_total > BLACKJACK
      puts "Dealer busted!"
      dealer_bust = true
      break
    end

    if dealers_cards_total >= DEALER_MUST_STAY
      dealer_stay = true
    else
      puts "The dealer hits."
      sleep 2
      dealers_cards << game_deck.pop
      puts "\nDealer was dealt #{dealers_cards[-1]}"
      print_dealers_cards(dealers_cards)
    end
    dealers_cards_total = total_of_cards(dealers_cards)
  end

  if (!player_bust && players_cards_total > dealers_cards_total) || dealer_bust || (player_blackjack && !dealer_blackjack)
    puts "You win!"
  elsif (!player_blackjack && dealer_blackjack)
    puts "You lose!"
  elsif (players_cards_total == dealers_cards_total) || (player_blackjack && dealer_blackjack)
    puts "It's a tie!"
  else
    puts "You lose!"
  end

  sleep 1
  puts "\nDo you want to play again? (Y/N)"
  continue_playing = gets.chomp.downcase

end while (continue_playing == 'y' || continue_playing == 'yes')

puts "Good bye"
