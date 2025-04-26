extends StaticBody2D

var stompUses = 2

func on_stomp():
	if stompUses > 0:
		stompUses -= 1
		global_position.y += 16
