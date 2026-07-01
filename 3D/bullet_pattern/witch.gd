extends CharacterBody3D

@onready var bullet_pattern_container: Node3D = $BulletPatternContainer

const ENERGY_BALL = preload("uid://d2ayqnussu52y")

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("actionE"):
		_shoot()
			
func _shoot():
	var pattern = bullet_pattern_container.get_children().pick_random()
	var bulletPositions = pattern.get_bullet_positions()
	
	for bulletPosition in bulletPositions:
		var energyBallNode = ENERGY_BALL.instantiate()
		
		get_tree().current_scene.add_child(energyBallNode)
	
		energyBallNode.global_position = bulletPosition
		energyBallNode.direction = bullet_pattern_container.global_position.direction_to(bulletPosition)
