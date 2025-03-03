extends Area2D

@export var levelTransistionType: Level_Transistion_Type
@export var spawnPoint: Marker2D
@export var nextScene: PackedScene

enum Level_Transistion_Type {CAMERA, SCENE}

const TRANSITION = preload("res://transition.tscn")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		_switch_level()

func _switch_level():
	var transistion = TRANSITION.instantiate()
	get_tree().root.add_child(transistion)

	if levelTransistionType == Level_Transistion_Type.CAMERA:
		await transistion.fade_in()
		
		get_viewport().get_camera_2d().global_position.x += 29 * 16
		var player = get_tree().get_first_node_in_group("player")
		player.global_position = spawnPoint.global_position
		
		await transistion.fade_out()
	elif levelTransistionType == Level_Transistion_Type.SCENE:
		await transistion.wipe_in()
		
		get_tree().change_scene_to_packed(nextScene)
		
		await transistion.wipe_out()
	
	transistion.queue_free()
