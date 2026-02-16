extends Node3D

signal rocket_done()

@onready var rocketbullet_low_001: MeshInstance3D = $rocketlaunchervariant2/rocketlaunchervariant/rocketbullet_low_001

const ROCKET = preload("uid://dimlrmxip57qq")

func shoot():
	rocketbullet_low_001.hide()
	
	var rocketNode = ROCKET.instantiate()
	get_tree().current_scene.add_child(rocketNode)
	rocketNode.global_transform = rocketbullet_low_001.global_transform
	rocketNode.finished.connect(_on_rocked_finished)

func _on_rocked_finished():
	rocketbullet_low_001.show()
	rocket_done.emit()
