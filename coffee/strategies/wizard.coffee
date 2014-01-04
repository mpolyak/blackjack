###
* Copyright (c) 2014 Michael Polyak. All rights reserved.
###

{Hand} = require "../hand"

class exports.WizardStrategy
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
			# Split on aces or eights.
			if hand.cards[0] is 1 or hand.cards[0] is 8
				return Hand.SPLIT

			# Dealer is showing a low card.
			if dealercard >= 2 and dealercard <= 6
				# Split on 2, 3, 6, 7 or 9.
				if hand.cards[0] in [2..3] or hand.cards[0] in [6..7] or hand.cards[0] is 9
					return Hand.SPLIT

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
						# Double-down on a 9 with two cards, otherwise hit.
						if hand.cards.length is 2
							return Hand.DOUBLE
						else
							return Hand.HIT

					when 10, 11
						# Double-down with two cards if hand is larger than the showing dealer card, otherwise hit.
						if hard > dealercard and hand.cards.length is 2
							return Hand.DOUBLE
						else
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
					when 12, 13, 14, 15
						# Hit on a medium hand.
						return Hand.HIT

					when 16, 17, 18
						# Double-down with two cards, otherwise hit.
						if hand.cards.length is 2
							return Hand.DOUBLE
						else
							# Do not hit with a soft 18.
							return Hand.HIT if soft isnt 18

			# Dealer is showing a high card.
			else
				# Don't hit on a big hand.
				return Hand.HIT if soft <= 18

		Hand.STAND