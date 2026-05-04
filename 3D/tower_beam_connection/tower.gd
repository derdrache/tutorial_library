extends Node3D

@onready var beam_connection_marker: Marker3D = $beamConnectionMarker

const BEAM = preload("uid://c14mh2v122iug")

func _ready() -> void:
	add_to_group("tower")

func add_tower_connections():
	for tower in get_tree().get_nodes_in_group("tower"):
		if tower == self: continue
		
		var beamNode = BEAM.instantiate()
		add_child(beamNode)
		
		var startPoint = beam_connection_marker.global_position
		var endPoint = tower.beam_connection_marker.global_position
	
		beamNode.length = startPoint.distance_to(endPoint)
		beamNode.global_position = (startPoint + endPoint) / 2
		
		beamNode.look_at(endPoint, Vector3.UP, true)
