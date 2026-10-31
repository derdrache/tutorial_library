extends CanvasLayer

@export var player1: Node2D
@export var player2: Node2D

@onready var sub_viewport_0: SubViewport = %SubViewport0
@onready var sub_viewport_1: SubViewport = %SubViewport1

func _ready() -> void:
	var currentWorld = get_tree().root.world_2d
	sub_viewport_0.world_2d = currentWorld
	sub_viewport_1.world_2d = currentWorld
	
	await get_tree().process_frame
	
	player1.reparent(sub_viewport_0)
	player2.reparent(sub_viewport_1)
