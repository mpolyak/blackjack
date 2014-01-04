###
*
* Copyright (c) 2014 Michael Polyak. All rights reserved.
* https://github.com/mpolyak/blackjack
*
###

{Hand} = require "./hand"

class exports.Player
	constructor: (@strategy, @betting) ->
		@reset()

	reset: ->
		@hands = []
		
		@maxWins = @maxLoss = 0
		@curWins = @curLoss = 0

		@consWins = {}
		@consLoss = {}

		@count = @draw = @wins = @loss = @amount = 0

		@newMin = @newMax = false

		@minAmount = @maxAmount = @minCount = @maxCount = @minFlat = @maxFlat = 0

		# Reset betting strategy and capital requirements.
		if @betting
			@betting.reset()

			@capital = @betting.amount
		else
			@capital = 1

	payout: (amount, last) ->
		++ @count

		if amount
			if amount > 0
				++ @curWins

				@curLoss = 0
			else
				++ @curLoss

				@curWins = 0

			@maxWins = @curWins if @curWins > @maxWins
			@maxLoss = @curLoss if @curLoss > @maxLoss

			if @curWins > 1
				unless @consWins[@curWins]?
					@consWins[@curWins] = 0

				++ @consWins[@curWins]

			if @curLoss > 1
				unless @consLoss[@curLoss]?
					@consLoss[@curLoss] = 0

				++ @consLoss[@curLoss]

			++ @wins if amount > 0
			++ @loss if amount < 0
		else
			++ @draw

		# Calculate number of hands from Min or Max amount to flat.
		if @amount
			if @newMax and @amount > 0 and @amount + amount <= 0
				@maxFlat = @count - @maxCount

				@newMax = false

			if @newMin and @amount < 0 and @amount + amount >= 0
				@minFlat = @count - @minCount

				@newMin = false

		@amount += amount

		if @amount < @minAmount
			@minAmount = @amount
			@minCount = @count

			@newMin = true
			@minFlat = 0

		if @amount > @maxAmount
			@maxAmount = @amount
			@maxCount = @count

			@newMax = true
			@maxFlat = 0

		# Update betting strategy and capital requirements.
		if @betting
			@betting.payout amount, last

			if @amount <= 0
				@capital += @betting.amount
		else
			if @amount <= 0
				++ @capital

	averageWins: ->
		average @consWins

	averageLoss: ->
		average @consLoss

	average = (values) ->
		total = 0

		for _, count of values
			total += count

		weighted = 0

		if total
			for value, count of values
				weighted += value * (count / total)

		weighted




		