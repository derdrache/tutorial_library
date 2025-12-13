extends Area2D

@export var breakBetween := 1.0
@export var duration := 2.0

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var timer: Timer = $Timer

func _ready() -> void:
	collision_shape_2d.disabled = true
	collision_shape_2d.shape.size.x = 0
	
	sprite_2d.material.set_shader_parameter("progress", 0.0)
	
	timer.wait_time = breakBetween

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.take_damage(1)


func _on_timer_timeout() -> void:
	await _create_laser()

	await get_tree().create_timer(duration).timeout
	
	await _remove_laser()
	
	timer.start()

func _create_laser():
	var tween = create_tween()
	
	tween.tween_property(collision_shape_2d, "shape:size:x", 16, 1)
	tween.parallel()
	tween.tween_method(_set_shader_value, 0.0, 1.0, 1)
	
	collision_shape_2d.disabled = false
	
	await tween.finished

func _set_shader_value(value):
	sprite_2d.material.set_shader_parameter("progress", value)

func _remove_laser():
	var tween = create_tween()
	
	tween.tween_property(collision_shape_2d, "shape:size:x", 0, 1)
	tween.parallel()
	tween.tween_method(_set_shader_value, 1.0, 0.0, 1)
	
	await tween.finished
	
	collision_shape_2d.disabled = true
