extends Node2D

var rawMaterial: Materials

func _ready() -> void:
	add_to_group("production_house")

func add_material(material:Materials):
	rawMaterial = material
	
func remove_material() -> Materials:
	if not rawMaterial: return
	
	var material = rawMaterial
	rawMaterial = null
	
	return material
