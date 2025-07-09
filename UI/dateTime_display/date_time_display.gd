extends Control

@onready var season_label: Label = %SeasonLabel
@onready var date_label: Label = %DateLabel
@onready var time_label: Label = %TimeLabel

var currentDate = Time.get_datetime_dict_from_datetime_string("2025-04-01T06:00:00", false)
var lastHour = 0

func _ready() -> void:
	_refresh_display()

func _refresh_display():
	if currentDate.month < 3 or currentDate.month == 12:
		season_label.text = "Winter"
	elif currentDate.month < 6:
		season_label.text = "Spring"
	elif currentDate.month < 9:
		season_label.text = "Summer"
	else:
		season_label.text = "Fall"
	
	date_label.text = _add_zero(currentDate.day) + "." + _add_zero(currentDate.month) + "."
	
	time_label.text = _get_time_label()
	
func _add_zero(number):
	if number < 10:
		return "0" + str(number)
	else:
		return str(number)

func _get_time_label():
	var hour: int
	var meridiem: String
	
	if currentDate.hour - 12 < 0:
		hour = currentDate.hour
		meridiem = "am"
	else:
		hour = currentDate.hour - 12
		meridiem = "pm"
		
	return _add_zero(hour) + ":" + _add_zero(currentDate.minute) + " " + meridiem
	
	
func _on_scene_time_updated(animationTime: Variant) -> void:
	var currentHour = int(animationTime / 1)
	
	if currentHour != lastHour:
		lastHour = currentHour
		var currentUnixTime = Time.get_unix_time_from_datetime_dict(currentDate)
		currentUnixTime += 3600
		currentDate = Time.get_datetime_dict_from_unix_time(currentUnixTime)
	
		_refresh_display()
