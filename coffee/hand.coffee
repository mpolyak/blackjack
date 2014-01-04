###
*
* Copyright (c) 2014 Michael Polyak. All rights reserved.
* https://github.com/mpolyak/blackjack
*
###

class exports.Hand
	@STAND 	= "stand"
	@HIT 	= "hit"
	@DOUBLE = "double"
	@SPLIT 	= "split"

	constructor: (@bet = 1) ->
		@cards = []

		@double = @split = 0

	hard: ->
		sum = 0

		for card in @cards
			sum += card
			
		sum

	soft: ->
		sum = ace = 0

		for card in @cards
			if card is 1
				unless sum + 11 > 21
					++ ace

					sum += 11
				else
					++ sum
			else
				sum += card

		while sum > 21 and ace > 0
			-- ace

			sum -= 10

		sum

	aces: ->
		(card for card in @cards when card is 1).length

	bust: ->
		@hard() > 21

	blackjack: ->
		not @split and @cards.length is 2 and @soft() is 21
