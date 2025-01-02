extends Control

@onready var catch_bar: ProgressBar = %CatchBar

var onCatch := false
var catchSpeed := 0.3
var catchingValue := 0.0

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_end"):
		var image = get_viewport().get_texture().get_image()
		image.save_png("res://screenshot.png")
	if onCatch: catchingValue += catchSpeed
	else: catchingValue -= catchSpeed
	
	if catchingValue < 0.0: catchingValue = 0
	elif catchingValue >= 100: _game_end()
	
	catch_bar.value = catchingValue

func _game_end() -> void:
	var tween = get_tree().create_tween()
	
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(self, "global_position", global_position + Vector2(0, 700), 0.5)
	
	await tween.finished

	get_tree().paused = false
	queue_free()


func _on_target_target_entered() -> void:
	onCatch = true

func _on_target_target_exited() -> void:
	onCatch = false
