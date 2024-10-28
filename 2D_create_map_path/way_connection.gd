extends Line2D

@export var hide:= true

var connectionPoints: Array

func _ready() -> void:
	connectionPoints = points
	
	if hide: clear_points()
	
	show_animation()
	
func show_animation() -> void:
	hide = true
	
	for point in connectionPoints:
		add_point(point)
		await get_tree().create_timer(0.2).timeout
