extends Node3D

func _physics_process(delta: float) -> void:
	if get_tree().get_frame() % 20 == 0:
		var randomValue = randi_range(-50, 50)
		
		$DamageIndicator.create_indicator_label(randomValue)
		
