extends Area3D

@export var currentAreaType: GameManager.Area_Type
@export var changeAreaType: GameManager.Area_Type

func _ready() -> void:
	add_to_group("changeArea")
	
	if GameManager.lastArea == changeAreaType:
		_set_player_position()
		
func _set_player_position():
	await get_tree().process_frame
	
	var player = get_tree().get_first_node_in_group("player")
	
	var targetPosition = player.global_position - global_position.direction_to($Marker3D.global_position)
	targetPosition.y = player.global_position.y
	
	player.look_at(targetPosition)
	player.global_position = $Marker3D.global_position

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		GameManager.change_area(currentAreaType)
		
		get_tree().change_scene_to_file(GameManager.areaDict[changeAreaType])
