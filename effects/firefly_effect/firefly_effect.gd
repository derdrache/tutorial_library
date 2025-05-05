extends GPUParticles2D

func _ready() -> void:
	lifetime = 0.1
	
	await get_tree().create_timer(0.1).timeout
	
	lifetime = 50
