extends StaticBody3D

@onready var selection_mesh: MeshInstance3D = %selectionMesh
@onready var objects: Node3D = $objects

const SOIL = preload("uid://d3s2lityv6yyh")

var hasSoil = false

func _ready() -> void:
	selection_mesh.hide()

func set_selection(boolean: bool):
	selection_mesh.visible = boolean

func tool_interaction(toolType: ITEM_BAR_ITEM.ITEM_TYPES):
	var canSoil = not hasSoil and toolType == ITEM_BAR_ITEM.ITEM_TYPES.HOE
	
	if canSoil:
		_add_soil()
	else:
		for object in objects.get_children():
			if object.has_method("tool_interaction"):
				object.tool_interaction(toolType)

func _add_soil():
	hasSoil = true
	
	var soilNode = SOIL.instantiate()
	objects.add_child(soilNode)
	soilNode.position.y = 0.05
	selection_mesh.position.y = 0.1
