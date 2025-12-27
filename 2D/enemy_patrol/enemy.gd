extends CharacterBody2D

@export var path : Path2D

@onready var vision: Area2D = $Vision

const SPEED = 200.0
const JUMP_VELOCITY = -400.0

var nextPosition: Vector2

func _physics_process(_delta: float) -> void:
	if not nextPosition:
		nextPosition = _get_closest_point()

	if global_position.distance_to(nextPosition) < 5:
		await _look_around()
		nextPosition = _get_next_point()

	var direction = global_position.direction_to(nextPosition)
	
	velocity = direction * SPEED
	
	look_at(global_position + direction)

	move_and_slide()


func _get_closest_point():
	var closestPoint: Vector2
	
	for index in path.curve.point_count:
		var currentPosition = path.curve.get_point_position(index)
		var distanceClosest = global_position.distance_to(closestPoint)
		var distance = global_position.distance_to(currentPosition)
		
		if not closestPoint or distance < distanceClosest:
			closestPoint = currentPosition
	
	return closestPoint

func _look_around():
	set_physics_process(false)
	
	var directions = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]
	
	for direction in directions:
		look_at(global_position + direction)
		await get_tree().create_timer(0.5).timeout
	
	set_physics_process(true)

func _get_next_point():
	var index = _get_current_point_index(nextPosition)
	
	index += 1
	
	if index > path.curve.point_count:
		index = 0
	
	return path.curve.get_point_position(index)

func _get_current_point_index(point: Vector2):
	for index in path.curve.point_count:
		if path.curve.get_point_position(index) == point:
			return index


func _on_vision_player_detecded(body: Node2D) -> void:
	if body.is_in_group("player"):
		set_physics_process(false)
		vision.set_color(Color(Color.RED, 0.3))
