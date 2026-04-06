extends CharacterBody3D

@export var movement := 3

func _ready() -> void:
	add_to_group("player_character")

func move(moveSequence: Array):
	var startPosition = moveSequence.pop_front()
	
	for movePosition in moveSequence:
		var direction =  movePosition - startPosition
		
		var lookDirection = direction
		lookDirection.y = 0
		
		look_at(global_position + lookDirection, Vector3.UP, true)

		var tween = get_tree().create_tween()
		tween.tween_property(self, "global_position", global_position + direction, 0.5)
		await tween.finished
		
		startPosition = movePosition
