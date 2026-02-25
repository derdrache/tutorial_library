extends Node3D

signal finished()

@export var force := 0.1

var duration: float
var rng = RandomNumberGenerator.new()

func start(animationDuration: float):
	duration = animationDuration

func _physics_process(delta: float) -> void:
	if duration > 0:
		var forceX = rng.randf_range(-1,1) * force
		var forceY = rng.randf_range(-1,1) * force
		
		get_parent().h_offset = forceX
		get_parent().v_offset = forceY
		
		duration -= delta
		
		if duration <= 0:
			finished.emit()
