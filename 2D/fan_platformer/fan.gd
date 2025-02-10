extends StaticBody2D

@export var fanStrength := 100

var playerBody

func _physics_process(delta: float) -> void:
	if playerBody: playerBody.velocity.y = -fanStrength
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		playerBody = body

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		playerBody = null
