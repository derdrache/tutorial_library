extends Node3D

@export var coinsCount := 20
@export var coinScale := 0.2

@onready var coins: Node3D = $coins
@onready var throw_area_shape: CollisionShape3D = $throwAreaShape

const COIN_A = preload("uid://d1wrj8nxa1ya7")

var randomGenerator = RandomNumberGenerator.new()
var animationSpeed = 0.75

func start():
	_place_coins()
	
func _place_coins():
	var coinModel = COIN_A.instantiate()
	for i in coinsCount:
		var coinNode = coinModel.duplicate()
		coinNode.scale = Vector3.ONE * coinScale
		coinNode.add_to_group("coins")
		
		var targetPosition = _get_floor_position(_get_random_area_position())
		
		coins.add_child(coinNode)
		
		var tween = create_tween()
		tween.tween_property(coinNode, "global_position", targetPosition, animationSpeed)
		tween.parallel()
		tween.tween_property(coinNode, "rotation_degrees:x", 360 * 5 + 90, animationSpeed)

func _get_random_area_position():
	var shape = throw_area_shape.shape
	
	#only works with cylinder shape
	var randomAngle = randomGenerator.randf_range(0, 2 * PI)
	var randomLength = shape.radius * sqrt(randomGenerator.randf())
	var direction = Vector3.RIGHT.rotated(Vector3.UP, randomAngle)
	
	return global_position + direction * randomLength

func _get_floor_position(currentPosition):
	var space_state: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state

	var raycastLength = 3
	var from: Vector3 = currentPosition
	var to: Vector3 = from + Vector3.DOWN * raycastLength

	var query = PhysicsRayQueryParameters3D.create(from, to)
	var result: Dictionary = space_state.intersect_ray(query)

	return result.position
