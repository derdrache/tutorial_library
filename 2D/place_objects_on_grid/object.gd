extends Sprite2D

@export var rect: Rect2

func get_global_rect():
	return Rect2(
		global_position - rect.size / 2,
		rect.size
	)
	
func set_on_place():
	modulate.a = 1
