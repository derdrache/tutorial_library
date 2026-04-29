extends Node3D

@onready var room_scene: Node3D = $RoomScene
@onready var room_scene_2: Node3D = $RoomScene2
@onready var end_position_marker: Marker3D = $endPositionMarker

var speed = 5.0
var distanceBetweenRooms: float

func _ready() -> void:
	distanceBetweenRooms = abs(room_scene.global_position.z - room_scene_2.global_position.z)

func _process(delta: float) -> void:
	room_scene.global_position.z -= speed * delta
	room_scene_2.global_position.z-= speed * delta
	
	var room1ReachedEnd = room_scene.global_position.z <= end_position_marker.global_position.z
	var room2ReachedEnd = room_scene_2.global_position.z <= end_position_marker.global_position.z
	
	if room1ReachedEnd:
		room_scene.global_position.z = room_scene_2.global_position.z + distanceBetweenRooms
	
	if room2ReachedEnd:
		room_scene_2.global_position.z = room_scene.global_position.z + distanceBetweenRooms
