extends TileMapLayer

@export var default := false

func _ready() -> void:
	set_active(default)

func set_active(boolean: bool) -> void:
	enabled = boolean
	
	for child: TileMapLayer in get_children():
		child.enabled = boolean
