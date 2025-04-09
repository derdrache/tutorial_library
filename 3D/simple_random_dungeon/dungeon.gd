extends Node3D

@export var roomCount := 5

@onready var rooms: Node3D = $rooms

const DUNGEON_ROOM = preload("res://dungeon_room.tscn")

func _ready() -> void:
	_create_dungeon()
	
func _create_dungeon():
	rooms.add_child(DUNGEON_ROOM.instantiate())
	
	for i in roomCount:
		var selectedRoom = _get_possible_rooms().pick_random()
		
		var newRoom = DUNGEON_ROOM.instantiate()
		rooms.add_child(newRoom)
		
		var connectionPoint = selectedRoom.connectionPoints.pick_random().global_position
		var spawnConnectionPoint = connectionPoint - selectedRoom.global_position
		
		selectedRoom.add_door(connectionPoint)
		newRoom.add_door(-spawnConnectionPoint, false)
		
		newRoom.global_position = selectedRoom.global_position + spawnConnectionPoint * 2
		
func _get_possible_rooms():
	return rooms.get_children()
