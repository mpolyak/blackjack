###
* Copyright (c) 2014 Michael Polyak. All rights reserved.
###

{Hand} = require "../hand"

class exports.DealerStrategy
	constructor: (@soft17 = true) ->

	play: (hand) ->
		unless hand.bust() and hand.blackjack()
			hard = hand.hard()
			soft = hand.soft()

			# Hit on hard 16 or on soft 17 if enabled.
			if hard < 17 or (@soft17 and soft > hard and soft is 17)
				return Hand.HIT

		Hand.STAND