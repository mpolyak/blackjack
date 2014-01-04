###
*
* Copyright (c) 2014 Michael Polyak. All rights reserved.
* https://github.com/mpolyak/blackjack
*
###

class exports.Util
	@precision: (number, decimal = 2) ->
		pow = Math.pow 10, decimal

		Math.round(number * pow) / pow

	@construct: (cons, args) ->
		F = ->
			cons.apply this, args

		F.prototype = cons.prototype

		new F()