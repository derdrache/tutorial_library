extends StaticBody3D

func _on_hurt_box_died() -> void:
	await _tree_falls_animation()
	
	queue_free()

func _tree_falls_animation():
	var tween = create_tween()
	
	tween.tween_property($Tree, "rotation:z", -1.5, 1)
	
	await tween.finished
