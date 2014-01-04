###
*
* Copyright (c) 2014 Michael Polyak. All rights reserved.
* https://github.com/mpolyak/blackjack
*
###

class exports.Cards
	constructor: (decks = 1) ->
		@drawn = 0

		@reshuffle = switch
			when decks > 3 then (52 * (decks - 2)) + Math.floor(52 * 2 * (0.0 + (Math.random() * 0.75)))
			when decks > 0 then (52 * (decks - 1)) + Math.floor(52 * 1 * (0.5 + (Math.random() * 0.25)))
			else 0

		cards = []

		while decks > 0
			cards = cards.concat deck()

			-- decks

		@cards = shuffle cards

	deck = ->
		cards = []

		for card in [1..10]
			suits = 4

			if card is 10
				suits *= 4

			while suits > 0
				cards.push card

				-- suits

		cards

	shuffle = (cards) ->
		shuffled = []

		while cards.length
			shuffled = shuffled.concat cards.splice(Math.floor(Math.random() * cards.length), 1)

		shuffled

	draw: ->
		unless @cards.length
			return 0

		-- @reshuffle if @reshuffle

		@cards.shift()

	shuffle: ->
		@reshuffle is 0