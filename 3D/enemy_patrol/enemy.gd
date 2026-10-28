extends CharacterBody3D

@export var path: Path3D

@onready var animation_player: AnimationPlayer = $Barbarian/AnimationPlayer
@onready var enemy_vision: Area3D = $EnemyVision
@onready var sprite_3d: Sprite3D = $Sprite3D

const SPEED = 5

var currentPathIndex = 0
var nextPosition: Vector3
var isLooking = false

func _ready() -> void:
	sprite_3d.hide()
	enemy_vision.hide()
	enemy_vision.player_detacted.connect(_on_player_detected)
	
	nextPosition = _get_next_position()

func _on_player_detected():
	sprite_3d.show()
	set_physics_process(false)
	animation_player.play("Idle")
	
	await get_tree().create_timer(1).timeout
	
	get_tree().reload_current_scene()

func _process(_delta: float) -> void:
	_set_animation()

func _set_animation():
	if isLooking:
		animation_player.play("Idle")
	elif velocity:
		animation_player.play("Running_A")
	else:
		animation_player.play("Idle")

func _physics_process(_delta: float) -> void:
	if global_position.distance_to(nextPosition) < 0.5 and not isLooking:
		await _look_around()
		currentPathIndex = _get_next_path_index()
		nextPosition = _get_next_position()

	if isLooking:
		return

	var direction = global_position.direction_to(nextPosition)
	
	velocity = direction * SPEED

	look_at(global_position + direction, Vector3.UP, true)

	move_and_slide()

func _get_next_position():
	return path.curve.get_point_position(currentPathIndex)

func _get_next_path_index():
	return wrap(currentPathIndex + 1, 0, path.curve.point_count)

func _look_around():
	isLooking = true
	animation_player.play("Idle")
	
	var directions = [Vector3.LEFT, Vector3.RIGHT, Vector3.FORWARD, Vector3.BACK]
	
	for direction in directions:
		look_at(global_position + direction, Vector3.UP, true)
		await get_tree().create_timer(0.5).timeout
	
	isLooking = false
