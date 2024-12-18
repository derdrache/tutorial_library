extends Area3D

signal next_round()

func _ready() -> void:
	add_to_group("startPoint")

func _on_body_entered(body: Node3D) -> void:
	var isPlayer = get_tree().get_first_node_in_group("player")
	
	if isPlayer: _check_round_done()
	
func _check_round_done():
	var checkPoints = get_tree().get_nodes_in_group("checkPoints")
	var roundDone = true
	
	for checkPoint in checkPoints:
		if not checkPoint.hasPassed: roundDone = false

	if roundDone: _next_round()
	
func _next_round():
	var checkPoints = get_tree().get_nodes_in_group("checkPoints")
	
	for checkPoint in checkPoints:
		checkPoint.hasPassed = false
	
	next_round.emit()
