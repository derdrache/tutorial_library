extends Node2D

@onready var ui: Control = $CanvasLayer/Ui
@onready var ball_spawn_marker: Marker2D = $ballSpawnMarker
@onready var ball: CharacterBody2D = $Ball
@onready var level_generator: Node2D = $LevelGenerator

var ballsLeft = 3
var score = 0

func _ready() -> void:
	ui.start_game(ballsLeft)
	
	_set_signals()
	
func _set_signals():
	for stone in get_tree().get_nodes_in_group("stone"):
		stone.hited.connect(_on_stone_hited)

func _on_stone_hited():
	score += 10
	ui.update_score(score)
	
	if level_generator.get_stone_count() == 0:
		ui.set_level_clear()

func _on_out_area_body_entered(_body: Node2D) -> void:
	ball.start()
	ballsLeft -= 1
	
	ui.update_balls(ballsLeft)
	
	if ballsLeft == 0:
		ui.set_game_over()
	else:
		ball.global_position = ball_spawn_marker.global_position
