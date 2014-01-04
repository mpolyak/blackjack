###
*
* Copyright (c) 2014 Michael Polyak. All rights reserved.
* https://github.com/mpolyak/blackjack
*
###

class exports.DoubleBet
	constructor: (@bet = 1, @wins = 2) ->
		@reset()

	reset: ->
		@amount = @bet

		@total = @count = 0

	payout: (amount, last) ->
		@total += amount

		unless last
			return

		if @total
			if @total > 0
				# Double bet amount if win count reached the threshold.
				if ++ @count >= @wins
					@amount *= 2

					@count = 0
			else
				@amount = @bet

				@count = 0

		@total = 0