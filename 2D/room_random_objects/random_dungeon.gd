extends Node2D

@export var maxRoomCount = 10

@onready var rooms: Node2D = $rooms

const RANDOM_ROOM = preload("res://randomRoom.tscn")

func _ready() -> void:
	_create_dungeon()
	
func _create_dungeon():
	var roomCount := randi_range(1, maxRoomCount)

	for room in roomCount: 
		await _create_room()
		
	_create_chests()
	
	_create_enemies()

func _create_room():
	var existingRooms = rooms.get_children()
	
	var newRoom = RANDOM_ROOM.instantiate()
	rooms.add_child(newRoom)
	newRoom.owner = get_tree().edited_scene_root
	
	var isFirstRoom = existingRooms.is_empty()
	if isFirstRoom: return
	
	var possibleRooms = []
	for room in existingRooms:
		if room == newRoom: continue
		possibleRooms.append(room)
	
	var selectedRoom = possibleRooms.pick_random()
	var success = await newRoom.connect_with(selectedRoom)
	
	var tries = 10
	while not success and tries > 0:
		selectedRoom = possibleRooms.pick_random()
		success = await newRoom.connect_with(selectedRoom)
		tries -= 1

	if not success:
		newRoom.queue_free()

func _create_chests():
	var chestCount = randi_range(4, rooms.get_child_count() * 1)

	for chest in chestCount:
		var selectedRoom = rooms.get_children().pick_random()
		selectedRoom.create_chest()

func _create_enemies():
	var enemyCount = randi_range(5, rooms.get_child_count() * 5)

	for enemy in enemyCount:
		var selectedRoom = rooms.get_children().pick_random()
		selectedRoom.create_enemy()

func _on_button_pressed() -> void:
	for node in rooms.get_children():
		node.queue_free()
		
	await get_tree().create_timer(0.1).timeout
	
	_ready()
