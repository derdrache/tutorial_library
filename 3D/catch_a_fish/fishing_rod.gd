extends Node3D

@onready var bobber: CharacterBody3D = %Bobber
@onready var fishing_line_starter_marker: Marker3D = %FishingLineStarterMarker
@onready var bobber_start_marker: Marker3D = %BobberStartMarker
@onready var fishing_line: MeshInstance3D = %FishingLine

var fish

func _ready() -> void:
	bobber.landed.connect(_on_bobber_landed)
	bobber.fish_hooked.connect(_on_bobber_fish_hooked)
	
	bobber.set_physics_process(false)
	fishing_line.hide()

func _physics_process(delta: float) -> void:
	_refresh_line()
	
func _refresh_line():
	var centerPosition = (fishing_line_starter_marker.global_position + bobber.global_position) / 2
	var distance = fishing_line_starter_marker.global_position.distance_to(bobber.global_position)
	
	fishing_line.global_position = centerPosition
	fishing_line.mesh.height = distance
	
	fishing_line.look_at(fishing_line_starter_marker.global_position)
	fishing_line.rotation_degrees.x -= 90

func start_fishing():
	fishing_line.show()
	
	_throw_bobber()
	
func _throw_bobber():
	bobber.velocity = global_basis * Vector3(1,1,0) * 3
	bobber.velocity.y = 6
	bobber.set_physics_process(true)

func stop_fishing():
	bobber.set_physics_process(false)
	
	var hasFish = fish
	if not hasFish:
		_remove_fish()
	
	var tween = create_tween()
	tween.tween_property(bobber, "global_position", bobber_start_marker.global_position, 0.5)
	await tween.finished
	
	fishing_line.hide()

func _remove_fish():
	get_tree().call_group("fish", "queue_free")

func _on_bobber_landed(ground):
	if not "water" in ground.name: 
		stop_fishing()
		return
	
	ground.start_fish_event()

func _on_bobber_fish_hooked(fishHooked):
	fish = fishHooked
	
	
