extends StaticBody3D

@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D

func selected(boolean: bool):
	var color: Color = Color.WHITE
	
	if boolean: color = Color.YELLOW
	
	_change_mesh_color(color)

func _change_mesh_color(color):
	mesh_instance_3d.mesh.material.albedo_color = color
