extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func fade_in():
	animation_player.play("fade")
	await animation_player.animation_finished
	
func fade_out():
	animation_player.play_backwards("fade")
	await animation_player.animation_finished
	
func wipe_in():
	animation_player.play("wipe_in")
	await animation_player.animation_finished

func wipe_out():
	animation_player.play("wipe_out")
	await animation_player.animation_finished
