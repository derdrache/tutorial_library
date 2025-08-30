extends Node

var startTime: int

func start_level():
	startTime = Time.get_unix_time_from_system()

func get_time_string():
	var endTime =  Time.get_unix_time_from_system()
	var timeDifference = int(endTime - startTime)
	
	return GameManager.time_convert(timeDifference, "minutes")

func time_convert(time_in_sec, convertion = "hour"):
	var seconds = time_in_sec%60
	var minutes = (time_in_sec/60)%60
	var hours = (time_in_sec/60)/60
	
	if convertion == "hour": return "%02d : %02d : %02d" % [hours, minutes, seconds]
	elif convertion == "minutes": return "%02d : %02d" % [minutes, seconds]
