extends StaticBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var isOpen = false

func _on_input_event(_viewport: Node, _event: InputEvent, _shape_idx: int) -> void:
	if Input.is_action_just_pressed("leftClick") and not isOpen:
		animated_sprite_2d.play("open")
