###
* Copyright (c) 2014 Michael Polyak. All rights reserved.
###

{Hand} = require "../hand"

class exports.SimpleStrategy
	constructor: (@rsa = true) ->

	play: (hand, dealercard) ->
		# Dealer card must be visible.
		return Hand.STAND unless dealercard

		# Stand if bust or on blackjack.
		if hand.bust() or hand.blackjack()
			return Hand.STAND 

		# Stand after a double-down.
		return Hand.STAND if hand.double

		# Stand after splitting aces unless another ace is dealt and re-splitting aces is enabled.
		if hand.split and hand.cards.length is 2 and (if @rsa then hand.aces() is 1 else hand.aces())
			return Hand.STAND

		# Hand can be split but not re-split unless re-splitting on aces is enabled.
		if hand.cards.length is 2 and hand.cards[0] is hand.cards[1] and (not hand.split or (@rsa and hand.split < 3 and hand.aces() is 2))
			switch hand.cards[0]
				when 1, 8
					# Split on aces or eights.
					return Hand.SPLIT

				when 2, 3, 7
					# Split 2, 3 and 7 if dealer card is between 2 and 7.
					return Hand.SPLIT if dealercard in [2..7]

				when 4
					# Split on 4 if dealer card is between 5 and 6.
					return Hand.SPLIT if dealercard in [5..6]

				when 6
					# Split on 6 if dealer card is between 2 and 6.
					return Hand.SPLIT if dealercard in [2..6]

				when 9
					# Split on 9 if dealer card is between 2 and 6 or between 8 and 9.
					return Hand.SPLIT if dealercard in [2..6] or dealercard in [8..9]


		hard = hand.hard()
		soft = hand.soft()

		#  Hard hand, no aces or aces count as one.
		if hard is soft
			# Dealer is showing a low card.
			if dealercard >= 2 and dealercard <= 6
				switch hard
					when 4, 5, 6, 7, 8
						# Hit on a small hand.
						return Hand.HIT

					when 9
						# Double-down on a 9 with two cards unless dealer card is a 2, otherwise hit.
						if dealercard isnt 2 and hand.cards.length is 2
							return Hand.DOUBLE
						else
							return Hand.HIT

					when 10, 11
						# Double-down with two cards if hand is larger than the showing dealer card, otherwise hit.
						if hard > dealercard and hand.cards.length is 2
							return Hand.DOUBLE
						else
							return Hand.HIT

					when 12
						# Hit if dealer card is either a 2 or a 3.
						if dealercard in [2..3]
							return Hand.HIT

			# Dealer is showing a high card.
			else
				switch hard
					when 4, 5, 6, 7, 8, 9, 12, 13, 14, 15, 16
						# Hit on a small or medium hand.
						return Hand.HIT

					when 10, 11
						# Double-down with two cards if hand is larger than the showing dealer card, otherwise hit.
						if hard > (if dealercard is 1 then 11 else dealercard) and hand.cards.length is 2
							return Hand.DOUBLE
						else
							return Hand.HIT

		# Soft hand, with aces that count as eleven.
		else
			# Dealer is showing a low card.
			if dealercard >= 2 and dealercard <= 6
				switch soft
					when 12
						# Hit on two aces.
						return Hand.HIT

					when 13, 14
						# Double-down with two cards on dealer card of 5 or 6, otherwise hit.
						if hand.cards.length is 2 and dealercard in [5..6]
							return Hand.DOUBLE
						else
							return Hand.HIT

					when 15, 16, 17
						# Double-down with two cards on dealer card between 4 and 6, otherwise hit.
						if hand.cards.length is 2 and dealercard in [4..6]
							return Hand.DOUBLE
						else
							return Hand.HIT

					when 18
						# Double-down with two cards on dealer card between 3 and 6, otherwise hit.
						if hand.cards.length is 2 and dealercard in [3..6]
							return Hand.DOUBLE
						else
							return Hand.HIT

			# Dealer is showing a high card.
			else
				switch soft
					when 12, 13, 14, 15, 16, 17
						# Hit on small or medium hand as well as on 17.
						return Hand.HIT

					when 18
						# Hit unless dealer card is either 7 or 8.
						unless dealercard is 7 or dealercard is 8
							return Hand.HIT

		Hand.STAND