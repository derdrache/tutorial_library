@tool
extends Node3D

@export var gunResource: GunResource

@onready var marker_3d: Marker3D = $Marker3D

func _ready() -> void:
	if gunResource:
		add_child(gunResource.model.instantiate())
		marker_3d.position = gunResource.bulletSpawnOffset

func get_damage_value():
	return gunResource.damage

func get_bullet_spawn_point():
	return marker_3d.global_position
