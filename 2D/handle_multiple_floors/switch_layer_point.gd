extends Area2D

@export var layer1: TileMapLayer
@export var layer2: TileMapLayer
@export var reverseSwitch := false

const MINIMUM_DISTANCE = 4

var enterPoint: Vector2

func _on_body_entered(body: Node2D) -> void:
	if body == get_tree().get_first_node_in_group("player"):
		enterPoint = body.global_position
		_switch_layer()

func _on_body_exited(body: Node2D) -> void:
	if body == get_tree().get_first_node_in_group("player"):
		var leaveOnSamePoint = enterPoint.distance_to(body.global_position) < MINIMUM_DISTANCE
		
		if leaveOnSamePoint and not reverseSwitch:
			_switch_layer()

func _switch_layer():
	layer1.set_active(not layer1.enabled)
	layer2.set_active(not layer2.enabled)
