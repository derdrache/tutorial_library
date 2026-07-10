@tool
extends StaticBody2D
class_name Stone

signal hited()

func _init() -> void:
	add_to_group("stone")

func get_hit():
	hited.emit()
	queue_free()

func set_new_color(newColor):
	var stylebox = $Panel.get_theme_stylebox("panel")
	stylebox.bg_color = newColor

func set_size(newSize):
	$Panel.size = newSize
	$CollisionShape2D.shape.size = newSize
	$CollisionShape2D.global_position = global_position + newSize / 2
