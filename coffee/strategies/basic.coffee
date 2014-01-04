###
* Copyright (c) 2014 Michael Polyak. All rights reserved.
###

{Hand} = require "../hand"

class exports.BasicStrategy
	S  = 0 # Stand
	H  = 1 # Hit
	P  = 2 # Split
	DS = 3 # Double or Stand
	DH = 4 # Double or Hit

	buildHard = (decks = 4) ->
		table =
		{
			 5: [ H,  H,  H,  H,  H,  H,  H,  H,  H,  H]
			 6: [ H,  H,  H,  H,  H,  H,  H,  H,  H,  H]
			 7: [ H,  H,  H,  H,  H,  H,  H,  H,  H,  H]
			 8: [ H,  H,  H,  H,  H,  H,  H,  H,  H,  H]
			 9: [ H, DH, DH, DH, DH, DH,  H,  H,  H,  H]
			10: [ H, DH, DH, DH, DH, DH, DH, DH, DH,  H]
			11: [DH, DH, DH, DH, DH, DH, DH, DH, DH, DH]
			12: [ H,  H,  H,  S,  S,  S,  H,  H,  H,  H]
			13: [ H,  S,  S,  S,  S,  S,  H,  H,  H,  H]
			14: [ H,  S,  S,  S,  S,  S,  H,  H,  H,  H]
			15: [ H,  S,  S,  S,  S,  S,  H,  H,  H,  H]
			16: [ H,  S,  S,  S,  S,  S,  H,  H,  H,  H]
			17: [ S,  S,  S,  S,  S,  S,  S,  S,  S,  S]
			18: [ S,  S,  S,  S,  S,  S,  S,  S,  S,  S]
			19: [ S,  S,  S,  S,  S,  S,  S,  S,  S,  S]
			20: [ S,  S,  S,  S,  S,  S,  S,  S,  S,  S]
			21: [ S,  S,  S,  S,  S,  S,  S,  S,  S,  S]
		}

		if decks is 1
			table[8][4] = DH
			table[8][5] = DH

		if decks >= 4
			table[9][1] = H

		table

	buildSoft = (decks) ->
		table =
		{
			13: [ H,  H,  H,  H, DH, DH,  H,  H,  H,  H]
			14: [ H,  H,  H, DH, DH, DH,  H,  H,  H,  H]
			15: [ H,  H,  H, DH, DH, DH,  H,  H,  H,  H]
			16: [ H,  H,  H, DH, DH, DH,  H,  H,  H,  H]
			17: [ H,  H, DH, DH, DH, DH,  H,  H,  H,  H]
			18: [ H, DS, DS, DS, DS, DS,  S,  S,  H,  H]
			19: [ S,  S,  S,  S,  S, DS,  S,  S,  S,  S]
			20: [ S,  S,  S,  S,  S,  S,  S,  S,  S,  S]
			21: [ S,  S,  S,  S,  S,  S,  S,  S,  S,  S]
		}

		if decks is 1
			table[13][3] = DH
			table[17][1] = DH
			table[18][1] = S

		if decks >= 4
			table[14][3] = H

		table

	buildPair = (decks) ->
		table =
		{
			 1: [ P,  P,  P,  P,  P,  P,  P,  P,  P,  P]
			 2: [ H,  P,  P,  P,  P,  P,  P,  H,  H,  H]
			 3: [ H,  P,  P,  P,  P,  P,  P,  H,  H,  H]
			 4: [ H,  H,  H,  H,  P,  P,  H,  H,  H,  H]
			 5: [ H, DH, DH, DH, DH, DH, DH, DH, DH,  H]
			 6: [ H,  P,  P,  P,  P,  P,  P,  H,  H,  H]
			 7: [ H,  P,  P,  P,  P,  P,  P,  P,  H,  H]
			 8: [ P,  P,  P,  P,  P,  P,  P,  P,  P,  P]
			 9: [ S,  P,  P,  P,  P,  P,  S,  P,  P,  S]
			10: [ S,  S,  S,  S,  S,  S,  S,  S,  S,  S]
		}

		if decks is 1
			table[3][7] = P
			table[4][3] = P
			table[7][9] = S
			table[9][0] = P

		if decks >= 4
			table[6][6] = H
			table[7][7] = H

		table

	constructor: (decks, @rsa = true) ->
		@hard = buildHard decks
		@soft = buildSoft decks
		@pair = buildPair decks

	play: (hand, dealercard) ->
		# Dealer card must be visible.
		return Hand.STAND unless dealercard

		# Stand if bust or on blackjack.
		if hand.bust() or hand.blackjack()
			return Hand.STAND 

		# Stand after a double-down.
		return Hand.STAND if hand.double

		# Stand after splitting aces unless another ace is dealt and re-splitting aces is enabled.
		if hand.split and hand.cards.length is 2 and (if @rsa then hand.aces() is 1 else hand.aces())
			return Hand.STAND

		hard = hand.hard()
		soft = hand.soft()

		# Default move is to stand.
		move = S

		# Hand can be split but not re-split unless re-splitting on aces is enabled.
		if hand.cards.length is 2 and hand.cards[0] is hand.cards[1] and (not hand.split or (@rsa and hand.split < 3 and hand.aces() is 2))
			move = @pair[hand.cards[0]][dealercard - 1]
		else
			#  Hard hand, no aces or aces count as one.
			if hard is soft
				move = @hard[hard][dealercard - 1]

			# Soft hand, with aces that count as eleven.
			else
				move = @soft[soft][dealercard - 1]

		# Double-down with two cards only.
		if move is DS or move is DH
			unless hand.cards.length is 2 and hard in [9..11]
				move = S if move is DS
				move = H if move is DH

		# Return move.
		switch move
			when H 		then Hand.HIT
			when P 		then Hand.Split
			when DS, DH then Hand.DOUBLE
			else 			 Hand.STAND
