extends Area2D

@export var scenePath = ""

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		_enter_dungeon()

func _enter_dungeon():
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file(scenePath)
