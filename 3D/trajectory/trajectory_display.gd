@tool
extends Node3D

@export var speed = 5.0:
	set(value):
		speed = value
		_refresh_throw_display()
@export var baseLineY := 0.0:
	set(value):
		baseLineY = value
		_refresh_throw_display()
@export var throwDirection = Vector3.BACK + Vector3.UP:
	set(value):
		throwDirection = value
		_refresh_throw_display()

var gravity = Vector3(0,-9.8, 0)

func _ready() -> void:
	_refresh_throw_display()

func _refresh_throw_display():
	_delete_old_display()
	
	_set_display()

func _delete_old_display():
	for child in get_children():
		child.queue_free()

func _set_display():
	var velocity = throwDirection * speed
	
	var currentPosition = global_position

	while currentPosition.y >= baseLineY:
		var fps = 120
		var delta = 1.0 / fps
		var mesh = _create_cylinder_mesh()

		velocity += gravity * delta

		currentPosition += velocity * delta
			
		add_child(mesh)	
		
		mesh.global_position = currentPosition

		mesh.look_at(currentPosition + velocity * delta)
		mesh.rotation_degrees.x += 90

func _create_cylinder_mesh():
	var mesh = MeshInstance3D.new()
	mesh.mesh = CylinderMesh.new()
	mesh.mesh.top_radius = 0.01
	mesh.mesh.bottom_radius = 0.01
	mesh.mesh.height = speed / 50

	return mesh
	
	
	
