extends Control

@onready var coin_label: Label = $coinLabel

var coins = 0

func _ready() -> void:
	hide()
	LevelManager.coin_collected.connect(_on_coin_collected)
	LevelManager.player_died.connect(_on_player_died)
	
func _on_coin_collected(value):
	coins += value
	coin_label.text = str(coins) + " Coins collected"

func _on_player_died():
	show()

func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_quit_b_utton_pressed() -> void:
	get_tree().quit()
