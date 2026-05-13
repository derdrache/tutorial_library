extends StaticBody3D

@export var speed := 10.0

func _ready() -> void:
	get_tree().create_timer(10).timeout.connect(queue_free)

func _physics_process(delta: float) -> void:
	global_position.z -= speed * delta
