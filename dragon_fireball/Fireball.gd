extends Area3D

@export var speed = 10
@export var damage = 500

func _process(delta):
	var dir = get_tree().get_first_node_in_group("player").global_transform.basis.z.normalized()
	global_position += dir * speed * delta


func _on_body_entered(body):
	if body.is_in_group("enemies"):
		body.take_damage(damage)
		queue_free()
