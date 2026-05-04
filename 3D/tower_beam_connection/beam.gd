extends Node3D

@export var length:= 2.0:
	set(value):
		length = value
		$MeshInstance3D.mesh.height = value
