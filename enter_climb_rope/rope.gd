extends Node2D

var tileSize = 16
var maxSwingDegree = 45
var changeRotation = -1

func _ready():
	add_to_group("rope")

func _physics_process(delta):
	rotation_degrees += changeRotation
	
	if rotation_degrees >= 180 + maxSwingDegree:
		changeRotation = -1
	elif rotation_degrees <= 180 - maxSwingDegree:
		changeRotation = 1
		

func set_rope(startPosition, endPosition):
	var distance = startPosition.distance_to(endPosition)
	
	global_position = endPosition
	

	look_at(startPosition)
	rotation_degrees += 90
	
	if rotation_degrees < 180: changeRotation = 1

	for i in int(distance / tileSize) + 1:
		var newRopeTile = $Sprite2D.duplicate()
		add_child(newRopeTile)
		newRopeTile.position = Vector2(0, -(i *16))
	
	var markerNode = Marker2D.new()
	markerNode.name = "playerPositionMaker"
	add_child(markerNode)
	markerNode.global_position = startPosition
	
func get_player_hang_position():
	return get_node("playerPositionMaker").global_position
