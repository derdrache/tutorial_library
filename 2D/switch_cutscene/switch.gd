extends Area2D

@export var connectedObject:Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var used := false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not used:
		await _use_switch()
		await _move_camera_to_object()
		await get_tree().create_timer(0.5).timeout
		await _move_camera_back(body)

func _use_switch():	
	used = true
	animated_sprite_2d.play("activate")
	
	await animated_sprite_2d.animation_finished
	
	connectedObject.activate()

func _move_camera_to_object():
	var camera = get_viewport().get_camera_2d()
	
	var tween = create_tween()
	tween.tween_property(camera, "global_position", connectedObject.global_position, 1.5)
	
	await tween.finished

func _move_camera_back(body):
	var camera = get_viewport().get_camera_2d()
	
	var tween = create_tween()
	tween.tween_property(camera, "global_position", body.global_position, 1.5)
	
	await tween.finished
