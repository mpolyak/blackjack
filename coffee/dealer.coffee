###
*
* Copyright (c) 2014 Michael Polyak. All rights reserved.
* https://github.com/mpolyak/blackjack
*
###

{Cards}	= require "./cards"
{Hand}	= require "./hand"
{Util}	= require "./util"
{Log}	= require "./log"

class exports.Dealer
	constructor: (@decks, @strategy) ->
		@hand = new Hand()

		@reset()

	reset: ->
		@cards = new Cards @decks

		# Reset drawn cards counts.
		@drawn = (0 for _ in [0...10])

	game: (players) ->
		@deal players
		@play players

		@payout players

	deal: (players) ->
		Log "Deal"

		# Re-shuffle cards.
		@reset() if @cards.shuffle()

		# Draw cards for players.
		for player, i in players
			hand = new Hand player.betting?.amount or 1

			hand.cards =
			[
				@cards.draw()
				@cards.draw()
			]

			player.hands = [hand]

			Log "Player #{i + 1}: #{hand.cards} #{hand.hard()}/#{hand.soft()} #{hand.bet}$"

			# Increment draw count for drawn cards.
			++ @drawn[card - 1] for card in hand.cards

		# Draw cards for dealer.
		@hand.cards =
		[
			@cards.draw()
			@cards.draw()
		]

		Log "Dealer: #{@hand.cards} #{@hand.hard()}/#{@hand.soft()}"

		# Increment draw count for drawn cards.
		++ @drawn[card - 1] for card in @hand.cards

	play: (players) ->
		Log "Play"

		# Game is over if dealer's face up card is an ace or a ten and he has a blackjack.
		if (@hand.cards[0] is 1 or @hand.cards[0] is 10) and @hand.blackjack()
			return

		hands = busts = stands = blackjacks = 0

		# Play each player's turn.
		for player, i in players
			j = 0

			# Play all the player's hands.
			while j < player.hands.length
				hand = player.hands[j]

				bust = stand = blackjack = false

				# Play the hand until it busts, stands or hits a blackjack.
				until bust or stand or blackjack
					# Get the next move for the player's hand.
					move = player.strategy.play hand, @hand.cards[0]

					Log "Player #{i + 1}.#{j + 1}: #{move} #{hand.cards} #{hand.hard()}/#{hand.soft()}"

					switch move
						when Hand.SPLIT
							# Split hand in two.
							one = new Hand hand.bet
							two = new Hand hand.bet

							# Carry over one card for each of the new hands and draw an additional one.
							one.cards = [hand.cards[0], @cards.draw()]
							two.cards = [hand.cards[1], @cards.draw()]

							# Increment split count for the hands.
							one.split = two.split = hand.split + 1

							Log "Player #{i + 1}.#{j + 1}.1: #{one.cards} #{one.hard()}/#{one.soft()} ##{one.split}"
							Log "Player #{i + 1}.#{j + 1}.2: #{two.cards} #{two.hard()}/#{two.soft()} ##{two.split}"

							# Increment draw count for drawn cards.
							++ @drawn[one.cards[1] - 1]
							++ @drawn[two.cards[1] - 1]

							# Replace original hand with the two new ones.
							player.hands.splice j, 1, one, two

							# Reset current hand to the first split hand and replay.
							hand = one

						when Hand.DOUBLE, Hand.HIT
							# Double the bet on a double-down.
							if move is Hand.DOUBLE
								hand.double = hand.bet

							# Draw another card.
							hand.cards.push card = @cards.draw()

							# Increment draw count for the drawn card.
							++ @drawn[card - 1]

							Log "Player #{i + 1}.#{j + 1}: #{hand.cards} #{hand.hard()}/#{hand.soft()}"

							# Hand is a blackjack, a bust or still in play.
							if hand.blackjack()
								blackjack = true
							else if hand.bust()
								bust = true

						else
							# Hand is blackjack or it stands.
							if hand.blackjack()
								blackjack = true
							else
								stand = true

				# Update hand play progress.
				++ busts 	  if bust
				++ stands 	  if stand
				++ blackjacks if blackjack

				# Advance to the next player hand.
				++ j

			# Update number of hands played.
			hands += j

		# Play dealer hand if not all players have busted or blackjacked.
		if busts isnt hands and blackjacks isnt hands
			bust = stand = blackjack = false

			# Play dealer hand until it busts, stands or hits a blackjack.
			until stand or bust or blackjack
				# Get the next move for the dealer's hand.
				move = @strategy.play @hand

				Log "Dealer: #{move} #{@hand.cards} #{@hand.hard()}/#{@hand.soft()}"

				if move is Hand.STAND
					# Hand is blackjack or it stands.
					if @hand.blackjack()
						blackjack = true
					else
						stand = true
				else
					# Draw another card.
					@hand.cards.push card = @cards.draw()

					# Increment draw count for the drawn card.
					++ @drawn[card - 1]

					Log "Dealer: #{@hand.cards} #{@hand.hard()}/#{@hand.soft()}"

					# Hand is a blackjack, a bust or still in play.
					if @hand.blackjack()
						blackjack = true
					else if @hand.bust()
						bust = true

	payout: (players) ->
		Log "Payout"

		soft 	  = @hand.soft()
		bust 	  = @hand.bust()
		blackjack = @hand.blackjack()

		# Payout each player.
		for player, i in players
			# Payout each player hand.
			for hand, j in player.hands
				# Calculate payout amount in a specific order.
				amount = switch
					# Lost the bet on a bust.
					when hand.bust()
						-hand.bet - hand.double

					# Won the bet on a blackjack.
					when hand.blackjack()
						hand.bet * (6 / 5)

					# Won the bet on dealer bust.
					when bust
						hand.bet + hand.double

					# Lost the bet on dealer blackjack.
					when blackjack
						-hand.bet - hand.double

					# Lost the bet on worse hand.
					when soft > hand.soft()
						-hand.bet - hand.double
					
					# Won the bet on a better hand.
					when soft < hand.soft()
						hand.bet + hand.double

					# Push.
					else
						0

				# Payout the player's hand.
				player.payout amount, j is player.hands.length - 1

				Log "Player #{i + 1}(#{j + 1}): #{amount}$ (#{Util.precision player.amount}$/#{Util.precision player.capital}$)"