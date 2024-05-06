extends Node

const MAX_LIVES = 10
var xcoins = 0
var xpoints = 0
var xlives = MAX_LIVES

func set_coins(coins):
	xcoins = coins

func set_points(points):
	xpoints = points
	
func set_lives(lives):
	xlives = lives
