###
* Copyright (c) 2014 Michael Polyak. All rights reserved.
###

{Hand} = require "../hand"

class exports.NeverBustStrategy
	constructor: () ->

	play: (hand) ->
		unless hand.bust() and hand.blackjack()
			# Never hit on a hard 12 or more.
			if hand.hard() < 12
				return Hand.HIT

		Hand.STAND