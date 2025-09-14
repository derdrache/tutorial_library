extends Path2D

@onready var path_follow_2d: PathFollow2D = %PathFollow2D

var inRange = false
var used = false
var tween: Tween

func _input(event: InputEvent) -> void:
	if not inRange: return
	
	if Input.is_action_just_pressed("interaction") and not used:
		_use_rope()
	elif Input.is_action_just_pressed("interaction") and used:
		_leave_rope()

func _use_rope():
	used = true
	var player = get_tree().get_first_node_in_group("player")
	player.reparent(path_follow_2d)
	
	_set_path_follow_progress(player.global_position)
	
	player.global_position = path_follow_2d.global_position
	player.set_physics_process(false)
	
	tween = create_tween()
	tween.finished.connect(_on_tween_finished)
	tween.tween_property(path_follow_2d, "progress_ratio", 1, 2)

func _set_path_follow_progress(playerPosition):
	var pathPoints = curve.get_baked_points()
	var length = pathPoints[0].distance_to(pathPoints[-1])
	
	var playerStartPosition = playerPosition - (global_position + pathPoints[0])

	path_follow_2d.progress_ratio = playerStartPosition.x / length

func _on_tween_finished():
	_leave_rope()

func _leave_rope():
	used = false
	tween.kill()
	
	var player = get_tree().get_first_node_in_group("player")
	player.reparent(get_tree().current_scene)
	player.set_physics_process(true)
	
	path_follow_2d.progress_ratio = 0

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		inRange = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		inRange = false
