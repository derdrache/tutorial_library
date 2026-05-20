extends Node

signal coin_collected(value)
signal player_died()

var coins := 0

func collect_coin(value):
	coins += value
	coin_collected.emit(value)

func game_over():
	player_died.emit()
	get_tree().paused = true
