extends StaticBody2D

@onready var point_light_2d: PointLight2D = $PointLight2D

func _ready() -> void:
	point_light_2d.enabled = false
	_set_signals()
	
func _set_signals():
	await get_tree().current_scene.ready
	
	var dayAndNightCycle : DayAndNightCycle= get_tree().get_first_node_in_group("dayAndNightCycle")
	dayAndNightCycle.changeDayTime.connect(_change_light)

func _change_light(dayTime: DayAndNightCycle.DAY_STATE):
	point_light_2d.enabled = not point_light_2d.enabled
