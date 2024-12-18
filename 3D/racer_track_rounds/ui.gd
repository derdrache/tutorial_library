extends CanvasLayer

var laps := 0

func _ready() -> void:
	var startPoint = get_tree().get_first_node_in_group("startPoint")
	startPoint.next_round.connect(_add_round)
	
func _add_round():
	laps += 1
	%roundCountLabel.text = str(laps)
