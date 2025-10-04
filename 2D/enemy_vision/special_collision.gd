extends CollisionPolygon2D

@export var show = true
@export var color: Color = Color(Color.GREEN, 0.3)

func _draw() -> void:
	if not show: return
	
	var points = get_polygon()
	draw_colored_polygon(points, color)

func change_color(newColor):
	color = newColor
	queue_redraw()
