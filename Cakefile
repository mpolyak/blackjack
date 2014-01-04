{exec} = require "child_process"

files =
[
	"coffee/cards.coffee"
	"coffee/hand.coffee"
	"coffee/dealer.coffee"
	"coffee/player.coffee"
	"coffee/table.coffee"
	"coffee/game.coffee"
	"coffee/strategies/neverbust.coffee"
	"coffee/strategies/dealer.coffee"
	"coffee/strategies/wizard.coffee"
	"coffee/strategies/simple.coffee"
	"coffee/strategies/basic.coffee"
	"coffee/betting/increment.coffee"
	"coffee/betting/double.coffee"
	"coffee/log.coffee"
	"coffee/util.coffee"
	"coffee/main.coffee"
]

task "sbuild", "build everything", ->
  for file in files
  	console.log file

  	exec "coffee -c #{file}", (error, stdout, stderr) ->
    	throw error if error