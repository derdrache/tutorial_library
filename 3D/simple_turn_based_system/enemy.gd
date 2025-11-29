extends CharacterBody3D

signal turn_done()
signal died(character: Node3D)

@onready var selection_mesh: MeshInstance3D = %SelectionMesh

func _init() -> void:
	add_to_group("enemy")

func _ready() -> void:
	selection_mesh.hide()

func set_select(boolean: bool):
	selection_mesh.visible = boolean

func set_active(boolean:bool):
	if boolean:
		var target = _get_target()
		await _attack(target)
		turn_done.emit()

func _get_target():
	var playerCharacter = get_tree().get_nodes_in_group("player")
	var randomTarget = playerCharacter.pick_random()
	
	return randomTarget

func _attack(enemy: Node3D):
	var startPosition = global_position
	
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", enemy.global_position, 0.5)
	
	# damage here
	
	tween.tween_property(self, "global_position", startPosition, 0.5)
	
	await tween.finished
