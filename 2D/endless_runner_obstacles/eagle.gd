extends Obstacle

func _process(delta: float) -> void:
	$AnimatedSprite2D.play("fly")
