@tool
extends Node3D

@export var refresh = false:
	set(value):
		if Engine.is_editor_hint():
			_refresh_editor_display()
@export var distance := 1.5
@export var bulletsPerWave := 10
@export var maxDegree := 360
@export var startDegree := 90
@export var sphereSpread := 3.0
@export var remove := false:
	set(value):
		if Engine.is_editor_hint():
			_delete_all_childs()

func _ready() -> void:
	_delete_all_childs()

func _refresh_editor_display():
	_delete_all_childs()
	
	for bulletPosition in get_bullet_positions():
		var marker = Marker3D.new()
		add_child(marker)
		marker.global_position = bulletPosition
		marker.owner = self

func _delete_all_childs():
	for child in get_children():
		child.queue_free()

func get_bullet_positions():
	var bulletPositions := []
	
	for i in bulletsPerWave:
		var spacing = TAU * (maxDegree / 360.0) / bulletsPerWave
	
		var angle = spacing * i + PI 
		var startPosition = Vector3.FORWARD * distance
		
		# circle spread
		var targetPosition = startPosition.rotated(Vector3.UP,angle - deg_to_rad(startDegree))
		if not bulletPositions.has(global_position + targetPosition):
			bulletPositions.append(global_position + targetPosition)
		
		# sphere Spread
		for x in sphereSpread:
			var sphereSpacing = TAU * 0.5 / sphereSpread
			var sphereAngle = sphereSpacing * x + PI
			
			var spherePosition = startPosition.rotated(Vector3.RIGHT, angle).rotated(Vector3.FORWARD, sphereAngle)
			if not bulletPositions.has(global_position + spherePosition):
				bulletPositions.append(global_position + spherePosition)
	
	return bulletPositions
