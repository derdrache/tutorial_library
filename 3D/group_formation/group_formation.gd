extends Node3D

@onready var formationNodes = [%Position1, %Position2]

enum Formation_Types {LINE, ROW, TRIANGLE}

const formationPosition = {
	Formation_Types.LINE: [Vector3(0,0,-4), Vector3(0,0,-6)],
	Formation_Types.ROW: [Vector3(-4,0,0), Vector3(4,0,0)],
	Formation_Types.TRIANGLE: [Vector3(-2,0,-4), Vector3(2,0,-4)]
}

func _ready() -> void:
	add_to_group("GroupFormation")
	
func change_formation(formation: Formation_Types):
	for i in formationNodes.size():
		formationNodes[i].position = formationPosition[formation][i]

func get_formation_position(companionNumber: int):
	return formationNodes[companionNumber - 1].global_position
