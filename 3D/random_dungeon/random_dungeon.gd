extends Node3D

@export var minRoomCount = 5
@export var maxRoomCount = 10

@onready var rooms: Node3D = $rooms

const RANDOM_ROOM = preload("res://random_room.tscn")

func _create_dungeon():
	_reset_rooms()
	
	await get_tree().create_timer(0.1).timeout
	
	var roomCount := randi_range(minRoomCount, maxRoomCount)

	for room in roomCount: 
		await _create_room()
	
func _reset_rooms():
	for room in rooms.get_children():
		room.queue_free()

func _create_room():
	var existingRooms = rooms.get_children()
	
	var newRoom = RANDOM_ROOM.instantiate()
	rooms.add_child(newRoom)
	
	var isFirstRoom = existingRooms.is_empty()
	if isFirstRoom: return
	
	var possibleRooms = []
	for room in existingRooms:
		if room == newRoom: continue
		possibleRooms.append(room)
	
	var selectedRoom
	var success
	var tries = 10
	
	while not success and tries > 0:
		selectedRoom = possibleRooms.pick_random()
		success = await newRoom.connect_with(selectedRoom)
		tries -= 1
	
	if not success:
		newRoom.queue_free()
		


func _on_button_pressed() -> void:
	_create_dungeon()
