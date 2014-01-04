###
*
* Copyright (c) 2014 Michael Polyak. All rights reserved.
* https://github.com/mpolyak/blackjack
*
###

class exports.IncrementBet
	constructor: (@bet = 1, @wins = 1) ->
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
				# Increment bet amount if win count reached the threshold.
				if ++ @count >= @wins
					@amount += @bet

					@count = 0
			else
				@amount = @bet

				@count  = 0

		@total = 0