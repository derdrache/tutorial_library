extends Control

@onready var score_label: Label = %scoreLabel
@onready var ball_label: Label = %ballLabel
@onready var game_over: Control = $GameOver
@onready var game_clear: Control = $GameClear

func _ready() -> void:
	game_over.hide()
	game_clear.hide()

func start_game(ballsLeft):
	score_label.text = "0"
	ball_label.text = str(ballsLeft)

func set_game_over():
	game_over.show()

func set_level_clear():
	game_clear.show()

func update_score(newValue):
	score_label.text = str(newValue)

func update_balls(newValue):
	ball_label.text = str(newValue)

func _on_game_over_button_pressed() -> void:
	get_tree().reload_current_scene()

func _on_game_clear_button_pressed() -> void:
	get_tree().reload_current_scene()
	# more in Part 4
