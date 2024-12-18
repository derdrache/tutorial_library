extends Area3D

@export var hasPassed = false

func _ready() -> void:
	add_to_group("checkPoints")

func _on_body_entered(body: Node3D) -> void:
	var isPlayer = get_tree().get_first_node_in_group("player")
	
	if isPlayer: hasPassed = true
