extends Area3D

signal player_detacted()

@export_category("LOS")
@export var precision := 3
@export var angle := 10.0
@export var losHeight := 1.0

@onready var raycasts: Node3D = $raycasts

var target: Node3D

func _ready() -> void:
	_set_ray_casts()

func _set_ray_casts():
	raycasts.global_position.y = losHeight
	var startAngle = -(angle / 2.0)
	
	for i in precision:
		var newRaycast = RayCast3D.new()
		raycasts.add_child(newRaycast)
		newRaycast.target_position = Vector3(0,0,1)
		newRaycast.rotation_degrees.y = startAngle + i * angle / precision


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		target = body

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		target = null
