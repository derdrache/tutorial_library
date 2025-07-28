extends CanvasLayer

@onready var combo_meter: Control = $ComboMeter

var comb_updates = [10, 15, 20, 30, 40, 50, 100, 150]

func _ready() -> void:
	for combo in comb_updates:
		await get_tree().create_timer(1).timeout
		combo_meter.update_combo(combo)
