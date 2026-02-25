extends Camera3D

@onready var camera_shake: Node3D = $cameraShake

func _ready() -> void:
	for i in 3:
		await get_tree().create_timer(2).timeout
		camera_shake.start(2)
		await camera_shake.finished
