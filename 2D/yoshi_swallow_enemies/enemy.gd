extends CharacterBody2D

var catcher: CharacterBody2D
var offSet = Vector2(0,8)

func _ready() -> void:
	add_to_group("enemy")

func _physics_process(delta: float) -> void:
	if catcher:
		var direction = global_position.direction_to(catcher.global_position)
		global_position = catcher.global_position + (direction.x * catcher.ray_cast_2d.target_position) + offSet
		
		if global_position.distance_to(catcher.global_position) < 18:
			catcher.eat()
			queue_free()

func catch(player: CharacterBody2D):
	set_physics_process(false)
	catcher = player
