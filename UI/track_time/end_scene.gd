extends Control

@onready var time_label: Label = %timeLabel

func _ready() -> void:
	time_label.text = GameManager.get_time_string()
