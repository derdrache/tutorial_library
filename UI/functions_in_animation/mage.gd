extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

const QTE = preload("res://QTE/qte.tscn")

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("shift"):
		animation_player.play("2H_Ranged_Shoot")
		
func start_qte():
	var qteNode = QTE.instantiate()
	add_child(qteNode)
