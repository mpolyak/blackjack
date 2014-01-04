###
*
* Copyright (c) 2014 Michael Polyak. All rights reserved.
* https://github.com/mpolyak/blackjack
*
###

{Util} = require "./util"
{Log} = require "./log"

class exports.Table
	constructor: (@games, @hands, @dealer, @players) ->

	play: ->
		summary =
			draw:		{min: 0, max: 0, avg: 0}
			wins:		{min: 0, max: 0, avg: 0}
			loss:		{min: 0, max: 0, avg: 0}
			maxWins:	{min: 0, max: 0, avg: 0}
			maxLoss:	{min: 0, max: 0, avg: 0}
			avgWins:	{min: 0, max: 0, avg: 0}
			avgLoss:	{min: 0, max: 0, avg: 0}
			edge:		{min: 0, max: 0, avg: 0}
			amount:		{min: 0, max: 0, avg: 0}
			capital:	{min: 0, max: 0, avg: 0}
			roi:		{min: 0, max: 0, avg: 0}
			expectancy:	{min: 0, max: 0, avg: 0}
			minAmount:	{min: 0, max: 0, avg: 0}
			maxAmount:	{min: 0, max: 0, avg: 0}
			minCount:	{min: 0, max: 0, avg: 0}
			maxCount:	{min: 0, max: 0, avg: 0}
			minFlat:	{min: 0, max: 0, avg: 0}
			maxFlat:	{min: 0, max: 0, avg: 0}

		count = game = 0

		# Play specified number of games.
		while game < @games
			++ game

			Log "Game #{game}/#{@games}"

			# Reset dealer and players.
			@dealer.reset()

			for player in @players
				player.reset()

			hand = 0

			# Play specified number of hands for the game.
			while hand < @hands
				++ hand

				Log "Hand #{hand}/#{@hands}"

				# Play player hands.
				@dealer.game @players

			# Summarize game play results.
			for player, i in @players when player.count
				record =
					draw:		player.draw / player.count
					wins:		player.wins / player.count
					loss:		player.loss / player.count
					maxWins:	player.maxWins
					maxLoss:	player.maxLoss
					avgWins:	player.averageWins()
					avgLoss:	player.averageLoss()
					edge:		if player.loss then (player.wins / player.loss) - 1 else if player.wins then 1 else 0
					amount:		player.amount
					capital:	player.capital
					roi:		if player.amount > 0 and player.capital then player.amount / player.capital else 0
					expectancy: player.amount / player.count
					minAmount:	player.minAmount
					maxAmount:	player.maxAmount
					minCount:	player.minCount
					maxCount:	player.maxCount
					minFlat:	player.minFlat
					maxFlat:	player.maxFlat

				Log "Strategy #{i + 1}: Draw #{Util.precision record.draw * 100}%, Wins #{Util.precision record.wins * 100}%, Loss #{Util.precision record.loss * 100}%",
					" Max Cons Wins #{record.maxWins}, Max Cons Loss #{record.maxLoss}, Avg Cons Wins #{Math.round record.avgWins}, Avg Cons Loss #{Math.round record.avgLoss}, Edge #{Util.precision record.edge * 100}%"

				Log "Betting #{i + 1}: Amount #{Util.precision record.amount}$, Capital #{Util.precision record.capital}$, ROI #{Util.precision record.roi * 100}%, Min Amount #{Util.precision record.minAmount}$, Max Amount #{Util.precision record.maxAmount}$",
					" Min Count #{Math.round record.minCount}, Max Count #{Math.round record.maxCount}, Min Flat #{Math.round record.minFlat}, Max Flat #{Math.round record.maxFlat}, Expectancy #{Util.precision record.expectancy}$"

				# Update summary with player results.
				summarize summary, record, count

				++ count

		# Calculate summary averages.
		if count
			for _, value of summary
				value.avg /= count

		summary

	summarize = (summary, record, count) ->
		for name, value of record
			if count
				summary[name].min = value if value < summary[name].min
				summary[name].max = value if value > summary[name].max
			else
				summary[name].min = value
				summary[name].max = value

			summary[name].avg += value
