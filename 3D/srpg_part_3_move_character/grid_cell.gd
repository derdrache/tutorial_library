extends Area3D

@onready var main_mesh: MeshInstance3D = $mainMesh
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D

var isHighlighted = false

func _ready() -> void:
	collision_shape_3d.disabled = Engine.is_editor_hint()

func position_in_rect(targetPosition):
	var cellSize = 1.0
	var xMatch = (targetPosition.x > global_position.x - cellSize / 2 
		and targetPosition.x < global_position.x + cellSize / 2)
	var zMatch = (targetPosition.z >= global_position.z - cellSize / 2 
		and targetPosition.z <= global_position.z + cellSize / 2)

	return xMatch and zMatch

func reset():
	_change_cell_color(Color.WHITE)
	isHighlighted = false

func highlight_movement():
	_change_cell_color(Color.YELLOW)
	isHighlighted = true
	
func _change_cell_color(color):
	var mesh = main_mesh.mesh.duplicate()
	
	var material = StandardMaterial3D.new()
	material.albedo_color = color
	
	mesh.surface_set_material(0,material )
	
	main_mesh.mesh = mesh
