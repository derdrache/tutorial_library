extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var playerOnDoor = 0

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		playerOnDoor += 1
		
		if playerOnDoor == 2:
			_open_door()

func _open_door():
	animated_sprite_2d.play("open")

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		playerOnDoor -= 1
