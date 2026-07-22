extends Node3D

@onready var soil_004: MeshInstance3D = $soil_004

var hasWater = false

func tool_interaction(toolType: ITEM_BAR_ITEM.ITEM_TYPES):
	var isWateringCan = toolType == ITEM_BAR_ITEM.ITEM_TYPES.WATERING_CAN
	
	if isWateringCan and not hasWater:
		watering_can_interaction()

func watering_can_interaction():
	hasWater = true
	
	_darkeing_mesh_color()	

func _darkeing_mesh_color():
	var soilMesh = soil_004.mesh
	var currentMaterial = soilMesh.surface_get_material(0)
	var currentColor = currentMaterial.albedo_color
	var newMaterial = StandardMaterial3D.new()
	newMaterial.albedo_color = currentColor * 0.75
	soil_004.set_surface_override_material(0, newMaterial) 
