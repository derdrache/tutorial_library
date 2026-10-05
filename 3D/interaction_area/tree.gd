extends StaticBody3D

@onready var interaction_area: Area3D = $InteractionArea

var canInteract = false

func _on_interaction_area_interaction_started() -> void:
	if not canInteract:
		canInteract = false
		_tree_falls_animation()

func _tree_falls_animation():
	interaction_area.hide()
	
	var tween = create_tween()
	
	tween.tween_property($Tree, "rotation:z", -1.5, 1)
	
	await tween.finished
	
	await get_tree().create_timer(1).timeout
	
	queue_free()
