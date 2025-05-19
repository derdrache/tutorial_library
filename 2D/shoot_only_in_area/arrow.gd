extends Area2D

@export var speed = 1000

var direction : Vector2

func _physics_process(delta):
	position += direction * speed * delta

func set_arrow(position, targetPosition):
	global_position = position
	direction = (targetPosition - position).normalized()
	
	look_at(targetPosition)
	
func _on_body_entered(body: Node2D) -> void:
	if body in get_tree().get_nodes_in_group("player"):
		queue_free()
