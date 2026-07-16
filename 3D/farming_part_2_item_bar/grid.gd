@tool
extends Node3D

@export var width := 5:
	set(value):
		width = value
		if Engine.is_editor_hint() and is_inside_tree():
			_ready()
@export var height := 5:
	set(value):
		height = value
		if Engine.is_editor_hint() and is_inside_tree():
			_ready()
@export var margin := 0.2:
	set(value):
		margin = value
		if Engine.is_editor_hint() and is_inside_tree():
			_ready()
@export var cellSize = 2:
		set(value):
			cellSize = value
			if Engine.is_editor_hint() and is_inside_tree():
				_ready()

const GROUND = preload("uid://064rp6nm3jai")

func _ready() -> void:
	_remove_grid()
	_create_grid()

func _remove_grid():
	for node in get_children():
		node.queue_free()

func _create_grid():
	for height in range(height):
		for width in range(width):
			var groundNode = GROUND.instantiate()
			
			add_child(groundNode)
			
			groundNode.global_position = global_position + Vector3(
				width,
				0, 
				height
				)
				
			if Engine.is_editor_hint():
				groundNode.owner = get_tree().edited_scene_root
