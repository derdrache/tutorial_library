extends Node3D

@export var connectionPoints: Array[Node3D]

@onready var layout: Node3D = $layout

const ENEMY = preload("res://enemy.tscn")
const WALL_DOORWAY = preload("res://assets/dungeon/wall_doorway.glb")

func _ready() -> void:
	_create_random_objects()
	
func _create_random_objects():
	var floors = _get_all_floors()
	
	_create_hole(floors)
	
	_create_enemy(floors)

func _get_all_floors():
	var floors = []
	
	for node in layout.get_children():
		if "floor" in node.name:
			floors.append(node)
			
	return floors

func _create_hole(floors):
	var randomPick = floors.pick_random()
	floors.erase(randomPick)
	
	randomPick.queue_free()

func _create_enemy(floors):
	var randomPick = floors.pick_random()
	floors.erase(randomPick)

	var enemy = ENEMY.instantiate()
	add_child(enemy)
	
	enemy.global_position = randomPick.global_position

func add_door(connectionPoint, withDoor = true):
	var wall = _get_connection_node(connectionPoint)

	connectionPoints.erase(wall)

	if withDoor:
		var door = WALL_DOORWAY.instantiate()
		add_child(door)
		door.global_position = wall.global_position
		door.rotation_degrees = wall.rotation_degrees
	
	wall.queue_free()

func _get_connection_node(connectionPoint):
	for child in connectionPoints:
		if child.global_position == connectionPoint:
			return child
			
			
			
			
