###
*
* Copyright (c) 2014 Michael Polyak. All rights reserved.
* https://github.com/mpolyak/blackjack
*
###

cp = require "child_process"

AsciiTable = require "ascii-table"

{Util} = require "./util"

# Play strategies.
DEALER_STRATEGY		= {path: "./strategies/dealer",	   name: "DealerStrategy",    args: []}
NEVER_BUST_STRATEGY	= {path: "./strategies/neverbust", name: "NeverBustStrategy", args: []}
BASIC_STRATEGY		= {path: "./strategies/basic",	   name: "BasicStrategy",	  args: [4]}
WIZARD_STRATEGY		= {path: "./strategies/wizard",    name: "WizardStrategy",	  args: []}
SIMPLE_STRATEGY		= {path: "./strategies/simple",	   name: "SimpleStrategy",    args: []}

# Betting strategies.
INCREMENT_BET = {path: "./betting/increment", name: "IncrementBet",	args: []}
DOUBLE_BET 	  = {path: "./betting/double",	  name: "DoubleBet",	args: []}

# Game tables.
STRATEGY_EDGE_TABLES = 
[
	{games: 1, hands: 1000000, strategy: "Dealer", 	   dealer: {decks: 4, strategy: DEALER_STRATEGY}, players: [{strategy: DEALER_STRATEGY}]}
	{games: 1, hands: 1000000, strategy: "Never Bust", dealer: {decks: 4, strategy: DEALER_STRATEGY}, players: [{strategy: NEVER_BUST_STRATEGY}]}
	{games: 1, hands: 1000000, strategy: "Basic", 	   dealer: {decks: 4, strategy: DEALER_STRATEGY}, players: [{strategy: BASIC_STRATEGY}]}
	{games: 1, hands: 1000000, strategy: "Wizard", 	   dealer: {decks: 4, strategy: DEALER_STRATEGY}, players: [{strategy: WIZARD_STRATEGY}]}
	{games: 1, hands: 1000000, strategy: "Simple", 	   dealer: {decks: 4, strategy: DEALER_STRATEGY}, players: [{strategy: SIMPLE_STRATEGY}]}
]

OPTIMAL_NUMBER_OF_HANDS_TABLES =
[
	{games: 100000, hands:  1, strategy: "Wizard", dealer: {decks: 4, strategy: DEALER_STRATEGY}, players: [{strategy: WIZARD_STRATEGY}]}
	{games: 100000, hands:  2, strategy: "Wizard", dealer: {decks: 4, strategy: DEALER_STRATEGY}, players: [{strategy: WIZARD_STRATEGY}]}
	{games: 100000, hands:  3, strategy: "Wizard", dealer: {decks: 4, strategy: DEALER_STRATEGY}, players: [{strategy: WIZARD_STRATEGY}]}
	{games: 100000, hands:  4, strategy: "Wizard", dealer: {decks: 4, strategy: DEALER_STRATEGY}, players: [{strategy: WIZARD_STRATEGY}]}
	{games: 100000, hands:  5, strategy: "Wizard", dealer: {decks: 4, strategy: DEALER_STRATEGY}, players: [{strategy: WIZARD_STRATEGY}]}
	{games: 100000, hands:  6, strategy: "Wizard", dealer: {decks: 4, strategy: DEALER_STRATEGY}, players: [{strategy: WIZARD_STRATEGY}]}
	{games: 100000, hands:  7, strategy: "Wizard", dealer: {decks: 4, strategy: DEALER_STRATEGY}, players: [{strategy: WIZARD_STRATEGY}]}
	{games: 100000, hands:  8, strategy: "Wizard", dealer: {decks: 4, strategy: DEALER_STRATEGY}, players: [{strategy: WIZARD_STRATEGY}]}
	{games: 100000, hands:  9, strategy: "Wizard", dealer: {decks: 4, strategy: DEALER_STRATEGY}, players: [{strategy: WIZARD_STRATEGY}]}
	{games: 100000, hands: 10, strategy: "Wizard", dealer: {decks: 4, strategy: DEALER_STRATEGY}, players: [{strategy: WIZARD_STRATEGY}]}
	{games: 100000, hands: 11, strategy: "Wizard", dealer: {decks: 4, strategy: DEALER_STRATEGY}, players: [{strategy: WIZARD_STRATEGY}]}
	{games: 100000, hands: 12, strategy: "Wizard", dealer: {decks: 4, strategy: DEALER_STRATEGY}, players: [{strategy: WIZARD_STRATEGY}]}
	{games: 100000, hands: 13, strategy: "Wizard", dealer: {decks: 4, strategy: DEALER_STRATEGY}, players: [{strategy: WIZARD_STRATEGY}]}
	{games: 100000, hands: 14, strategy: "Wizard", dealer: {decks: 4, strategy: DEALER_STRATEGY}, players: [{strategy: WIZARD_STRATEGY}]}
	{games: 100000, hands: 15, strategy: "Wizard", dealer: {decks: 4, strategy: DEALER_STRATEGY}, players: [{strategy: WIZARD_STRATEGY}]}
	{games: 100000, hands: 16, strategy: "Wizard", dealer: {decks: 4, strategy: DEALER_STRATEGY}, players: [{strategy: WIZARD_STRATEGY}]}
	{games: 100000, hands: 17, strategy: "Wizard", dealer: {decks: 4, strategy: DEALER_STRATEGY}, players: [{strategy: WIZARD_STRATEGY}]}
	{games: 100000, hands: 18, strategy: "Wizard", dealer: {decks: 4, strategy: DEALER_STRATEGY}, players: [{strategy: WIZARD_STRATEGY}]}
	{games: 100000, hands: 19, strategy: "Wizard", dealer: {decks: 4, strategy: DEALER_STRATEGY}, players: [{strategy: WIZARD_STRATEGY}]}
	{games: 100000, hands: 20, strategy: "Wizard", dealer: {decks: 4, strategy: DEALER_STRATEGY}, players: [{strategy: WIZARD_STRATEGY}]}
]

OPTIMAL_BETTING_STRATEGY_TABLES =
[
	{games: 1000000, hands: 6, betting: "Constant",	 dealer: {decks: 4, strategy: DEALER_STRATEGY}, players: [{strategy: WIZARD_STRATEGY}]}
	{games: 1000000, hands: 6, betting: "Increment", dealer: {decks: 4, strategy: DEALER_STRATEGY}, players: [{strategy: WIZARD_STRATEGY, betting: INCREMENT_BET}]}
	{games: 1000000, hands: 6, betting: "Double",	 dealer: {decks: 4, strategy: DEALER_STRATEGY}, players: [{strategy: WIZARD_STRATEGY, betting: DOUBLE_BET}]}
]

# Select game tables to play.
tables = OPTIMAL_BETTING_STRATEGY_TABLES

results = []

# Play game tables in parallel.
for table, i in tables
	game = cp.fork "#{__dirname}/game.js"

	game.on "message", (data) ->
		results.push data

		# All tables have played, process results.
		process() if results.length is tables.length

	# Send table information to the game process.
	game.send {index: i, table: table}

STRATEGY_FIELDS =
[
	{name: "Wins %",		field: "wins",	  percent: 100}
	{name: "Loss %",		field: "loss",	  percent: 100}
	{name: "Draw %",		field: "draw",	  percent: 100}
	{name: "Max Cons Wins",	field: "maxWins", percent: 0, round: true}
	{name: "Max Cons Loss",	field: "maxLoss", percent: 0, round: true}
	{name: "Avg Cons Wins",	field: "avgWins", percent: 0, round: true}
	{name: "Avg Cons Loss",	field: "avgLoss", percent: 0, round: true}
	{name: "Edge %",		field: "edge",	  percent: 100}
]

BETTING_FIELDS =
[
	{name: "Min PnL $",		   field: "minAmount",	percent: 1}
	{name: "Max PnL $",		   field: "maxAmount",	percent: 1}
	{name: "PnL $",			   field: "amount",		percent: 1}
	{name: "Capital $",	   	   field: "capital",	percent: 1}
	{name: "ROI %",	   		   field: "roi",		percent: 100}
	{name: "Hands to Min PnL", field: "minCount",	percent: 0, round: true}
	{name: "Hands to Max PnL", field: "maxCount",	percent: 0, round: true}
	{name: "Min PnL to Flat",  field: "minFlat",	percent: 0, round: true}
	{name: "Max PnL to Flat",  field: "maxFlat",	percent: 0, round: true}
	{name: "Exp per Hand $",   field: "expectancy",	percent: 1}
]

process = ->
	results.sort (a, b) ->
		if a.index < b.index then -1 else if a.index > b.index then 1 else 0

	output = new AsciiTable("MIN/AVG/MAX or VALUE")

	# Populate output table columns.
	columns = ["#", "Games", "Hands"]
	
	if tables.some((table) -> table.strategy)
		columns = columns.concat ["Strategy"].concat(item.name for item in STRATEGY_FIELDS)

	if tables.some((table) -> table.betting)
		columns = columns.concat ["Betting"].concat(item.name for item in BETTING_FIELDS)

	output.setHeading columns

	# Process each table results and write out a summary row.
	for result in results
		table = tables[result.index]

		# Compose summary row.
		row = [result.index + 1, table.games, table.hands]

		if table.strategy
			row = row.concat [table.strategy].concat(recordFields STRATEGY_FIELDS, result.summary)

		if table.betting
			row = row.concat [table.betting].concat(recordFields BETTING_FIELDS, result.summary)

		output.addRow row

	console.log output.toString()

recordFields = (fields, record) ->
	for item in fields
		value = ""

		if record[item.field]?
			{min, max, avg} = record[item.field]

			if item.percent
				min = Util.precision min * item.percent
				max = Util.precision max * item.percent
				avg = Util.precision avg * item.percent

			else if item.round
				min = Math.round min
				max = Math.round max
				avg = Math.round avg

			unless min is max is avg
				value = "#{min}/#{avg}/#{max}"
			else
				value = avg

		value