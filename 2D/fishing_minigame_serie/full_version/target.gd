extends Area2D

signal target_entered()
signal target_exited()

const SPEED := 200

var on_fish := false

func _physics_process(delta: float) -> void:
	_check_on_fish()

	var direction := Vector2.ZERO
	direction.x = Input.get_axis("ui_left", "ui_right")
	direction.y = Input.get_axis("ui_up", "ui_down")
	
	global_position += direction * SPEED * delta

func _check_on_fish() -> void:
	var bodies := get_overlapping_bodies()

	if bodies.is_empty() and on_fish: 
		on_fish = false
		target_exited.emit()
	elif not bodies.is_empty() and not on_fish: 
		on_fish = true
		target_entered.emit()
