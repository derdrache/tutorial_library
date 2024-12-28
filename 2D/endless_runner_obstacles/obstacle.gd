extends CharacterBody2D
class_name Obstacle

@export var spawnPoint = Vector2.ZERO

const SPEED = 100

func _ready() -> void:
	$Area2D.body_entered.connect(_on_body_entered)
	
func _on_body_entered(body):
	if body.is_in_group("player"):
		body.take_damage(1)

func _physics_process(delta: float) -> void:
	velocity.x = -SPEED

	move_and_slide()
	
	if global_position.x <= 0:
		queue_free()

func get_spawn_point():
	return spawnPoint
