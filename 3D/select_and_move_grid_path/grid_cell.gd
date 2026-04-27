extends MeshInstance3D

func change_color(newColor):
	var material := StandardMaterial3D.new()
	material.albedo_color = newColor
	set_surface_override_material(0, material)
