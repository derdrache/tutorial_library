extends Control

@onready var label: Label = $Label
@onready var event_bar: TextureRect = $EventBar

	
func _on_event_bar_bonus_done() -> void:
	label.text = "Bonus"
	_reset()

func _on_event_bar_fail() -> void:
	label.text = "Fail"
	_reset()

func _on_event_bar_normal_done() -> void:
	label.text = "Normal"
	_reset()


func _on_event_bar_succsess_done() -> void:
	label.text = "Fast Done"
	_reset()

func _reset():
	await get_tree().create_timer(1).timeout
	label.text = ""
	event_bar.reset()
