extends Node2D

@onready var bridge_down: TileMapLayer = $environment/TileMap/BridgeDown
@onready var bridge_above: TileMapLayer = $environment/TileMap/BridgeAbove


func _ready() -> void:
	for layerSwitch in get_tree().get_nodes_in_group("layer_switch"):
		layerSwitch.change_layer.connect(_change_layer)
		
func _change_layer():
	bridge_down.enabled = not bridge_down.enabled
	bridge_above.enabled = not bridge_above.enabled
