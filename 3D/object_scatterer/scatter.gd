@tool
extends Node3D

@export var objects: Array[PackedScene]:
	set(value):
		objects = value
		_refresh()

@export var amount := 10:
	set(value):
		amount = value
		_refresh()
		
@export_range(0,1) var randomScale := 0.0:
	set(value):
		randomScale = value
		_refresh()
		
@export var scatterSeed := 0:
	set(value):
		scatterSeed = value
		_refresh()

@onready var objects_container: Node3D = $objectsContainer

var collisionShape: CollisionShape3D
var randomGenerator = RandomNumberGenerator.new()

func _ready() -> void:
	_refresh()

func _on_child_entered_tree(node: Node) -> void:
	if node is CollisionShape3D:
		collisionShape = node
		collisionShape.changed.connect(_refresh)

func _refresh():
	if not is_node_ready(): return
	
	for child in objects_container.get_children():
		child.queue_free()

	if not collisionShape: return
	
	_set_random_seed()
	
	_set_objects()

func _set_random_seed():
	seed(scatterSeed)
	collisionShape.randomGenerator.set_seed(scatterSeed)
	randomGenerator.set_seed(scatterSeed)

func _set_objects():
	for i in amount:
		var randomObject = objects.pick_random().instantiate()
		
		var randomPosition = collisionShape.get_random_position()
		var shapeHeight = collisionShape.shape.height
		var floorPosition = _get_floor_position(randomPosition, shapeHeight)
		
		if not floorPosition:
			continue
		
		objects_container.add_child(randomObject)
		
		randomObject.global_position = floorPosition
		randomObject.scale = Vector3.ONE * randomGenerator.randf_range(1.0 - randomScale, 1)

func _get_floor_position(startPosition, height):
	var params = PhysicsRayQueryParameters3D.new()
	
	params.from = Vector3(startPosition.x, startPosition.y + height /2 , startPosition.z)
	params.to = Vector3(startPosition.x, startPosition.y - height / 2, startPosition.z)

	var worldspace = get_world_3d().direct_space_state
	var result = worldspace.intersect_ray(params)

	if result:
		return result.position
		
		
