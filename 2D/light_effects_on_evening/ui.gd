extends CanvasLayer

@onready var sun: TextureRect = $Sun
@onready var moon: TextureRect = $Moon

func _ready() -> void:
	_set_signals()
	
func _set_signals():
	await get_tree().current_scene.ready
	
	var dayAndNightCycle : DayAndNightCycle= get_tree().get_first_node_in_group("dayAndNightCycle")
	dayAndNightCycle.changeDayTime.connect(_change_day_icons)

func _change_day_icons(dayTime: DayAndNightCycle.DAY_STATE):
	if dayTime == DayAndNightCycle.DAY_STATE.NOON:
		sun.show()
		moon.hide()
	elif dayTime == DayAndNightCycle.DAY_STATE.EVENING:
		sun.hide()
		moon.show()
