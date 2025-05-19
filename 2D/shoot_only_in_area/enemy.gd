extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const ARROW = preload("res://arrow.tscn")

var target: CharacterBody2D
var direction = Vector2.ZERO

func _physics_process(delta: float) -> void:
	if target:
		var targetPosition = target.global_position
		direction = (targetPosition - global_position).normalized()
		
	_set_animation()

func _set_animation():
	if direction.x < 0: animated_sprite_2d.flip_h = true
	elif direction.x > 0: animated_sprite_2d.flip_h = false
	
	if target:
		animated_sprite_2d.play("shoot_side")
	else:
		animated_sprite_2d.play("idle")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body in get_tree().get_nodes_in_group("player"):
		target = body

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body in get_tree().get_nodes_in_group("player"):
		target = null

func _on_animated_sprite_2d_frame_changed() -> void:
	if "shoot_side" in animated_sprite_2d.animation and animated_sprite_2d.frame == 6:
		_shoot()

func _shoot():
	var targetPosition = target.global_position
	var arrow = ARROW.instantiate()
	arrow.set_arrow(global_position, targetPosition)
	get_parent().add_child(arrow)
