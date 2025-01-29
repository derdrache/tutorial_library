extends Node3D

@export var speed:= 40.0
@export var spawnTime := 1.0

@onready var ray_cast_3d: RayCast3D = $RayCast3D

var direction:Vector3

func _ready() -> void:
	get_tree().create_timer(spawnTime).timeout.connect(queue_free)

func _process(delta: float) -> void:
	if ray_cast_3d.is_colliding(): queue_free()
		
	position += direction * speed * delta
	scale *= 0.96

func set_direction(newDirection):
	direction = newDirection
