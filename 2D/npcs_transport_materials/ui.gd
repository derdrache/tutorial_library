extends CanvasLayer

@onready var wood_label: Label = %WoodLabel

func _ready() -> void:
	_connect_signals()
	
func _connect_signals():
	for storage in get_tree().get_nodes_in_group("storage_house"):
		storage.add_raw_material.connect(_add_material)
		
func _add_material(material: Materials):
	if material.type == Materials.TYPES.WOOD:
		var storage = int(wood_label.text)
		wood_label.text = str(storage + material.quantity)
