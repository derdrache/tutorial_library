extends StaticBody3D

@onready var tree: Node3D = $Tree
@onready var fruits: Node3D = $fruits

var inRange := false
var doShake := false
var shakeForce = 0.1
var shakeDuration = 0.3

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("actionE") and inRange:
		_shake()

func _shake():
	if fruits.get_child_count() > 0:
		var randomFruit = fruits.get_children().pick_random()
		randomFruit.active = true
		randomFruit.reparent(get_tree().current_scene)
		
	doShake = true
	
	await get_tree().create_timer(shakeDuration).timeout
	
	doShake = false

func _process(_delta: float) -> void:
	if not doShake: return
	
	tree.position = Vector3(
		randf_range(shakeForce, -shakeForce), 
		0, 
		randf_range(shakeForce, -shakeForce))

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		inRange = true

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		inRange = false
