extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _physics_process(delta: float) -> void:
	
	_look_at_player()

	move_and_slide()

func _look_at_player():
	var player = get_tree().get_first_node_in_group("player")
	
	animated_sprite_2d.flip_h = (global_position - player.global_position).x > 0


func _on_hurt_box_hurted() -> void:
	_hurt_animation()

func _hurt_animation():
	var tween = create_tween()
	
	tween.tween_property(animated_sprite_2d, "modulate", Color(1.0, 0.0, 0.0), 0.05)
	tween.tween_property(animated_sprite_2d, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.05)
