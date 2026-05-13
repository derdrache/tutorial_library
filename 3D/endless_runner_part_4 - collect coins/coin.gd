extends Area3D

@export var speed = 10
@export var coinValue := 1

func _physics_process(delta: float) -> void:
	global_position.z -= speed * delta

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		LevelManager.collect_coin(coinValue)
		queue_free()
