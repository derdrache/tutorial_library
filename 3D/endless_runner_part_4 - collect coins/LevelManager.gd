extends Node

signal coin_collected(value)

var coins := 0

func collect_coin(value):
	coins += value
	coin_collected.emit(value)
