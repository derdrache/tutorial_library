extends CharacterBody3D

@onready var animation_player: AnimationPlayer = $Knight/AnimationPlayer

func _physics_process(_delta: float) -> void:
	animation_player.play("Running_A")
