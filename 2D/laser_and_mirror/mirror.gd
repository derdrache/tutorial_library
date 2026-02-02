extends StaticBody2D

enum REFLECT_DIRECTION {NW, NE, SE, SW}

var reflectionDirection: REFLECT_DIRECTION = REFLECT_DIRECTION.NE

func get_reflect_direction(impactDirection):
	var possibleDirections = _get_possible_directions()

	if -impactDirection in possibleDirections:
		possibleDirections.erase(-impactDirection)
		return possibleDirections[0]
		
func _get_possible_directions():
	match reflectionDirection:
		REFLECT_DIRECTION.NW: return [Vector2.UP, Vector2.LEFT]
		REFLECT_DIRECTION.NE: return [Vector2.UP, Vector2.RIGHT]
		REFLECT_DIRECTION.SW: return [Vector2.DOWN, Vector2.LEFT]
		REFLECT_DIRECTION.SE: return [Vector2.DOWN, Vector2.RIGHT]

func _on_input_event(_viewport: Node, _event: InputEvent, _shape_idx: int) -> void:
	if Input.is_action_just_pressed("leftClick"):
		rotate(deg_to_rad(90))
		reflectionDirection += 1

		if reflectionDirection == REFLECT_DIRECTION.keys().size():
			reflectionDirection = 0

		var laser = get_tree().get_first_node_in_group("laser")
		laser.refresh_laser()
