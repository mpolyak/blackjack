###
*
* Copyright (c) 2014 Michael Polyak. All rights reserved.
* https://github.com/mpolyak/blackjack
*
###

{Dealer} = require "./dealer"
{Player} = require "./player"
{Table}	 = require "./table"
{Util} 	 = require "./util"

process.on "message", (data) ->
	table = data.table

	# Create table dealer.
	dealer = new Dealer(table.dealer.decks, Util.construct(require(table.dealer.strategy.path)[table.dealer.strategy.name],
		table.dealer.strategy.args))

	# Create table players.
	players = (for player in table.players
		new Player(Util.construct(require(player.strategy.path)[player.strategy.name], player.strategy.args),
			Util.construct(require(player.betting.path)[player.betting.name], player.betting.args) if player.betting))

	# Create the game table.
	table = new Table table.games, table.hands, dealer, players

	# Play and send back the results.
	process.send index: data.index, summary: table.play()

	process.disconnect()