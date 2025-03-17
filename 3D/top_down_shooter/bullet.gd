extends Area3D

var speed = 15
var direction: Vector3

func _ready() -> void:
	await get_tree().create_timer(2).timeout
	
	queue_free()

func _physics_process(delta: float) -> void:
	if direction:
		global_position += direction * speed * delta
