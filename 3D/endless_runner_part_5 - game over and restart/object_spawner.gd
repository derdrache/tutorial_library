extends Node3D

@export var objects: Array[PackedScene]
@export var spawnPoints: Array[Marker3D]
@export var coin: PackedScene
@export var objectInterval := 3

@onready var timer: Timer = $Timer

var currentInternavel = 0
var currentCoinSpawnLine: Marker3D

func _ready() -> void:
	currentCoinSpawnLine = spawnPoints.pick_random()
	
func _on_timer_timeout() -> void:
	currentInternavel += 1
	
	if currentInternavel == objectInterval:
		currentInternavel = 0
		_set_object()
	else:
		_set_coin()

func _set_object():
	var randomObject = objects.pick_random()
	var randomSpawnPoint = spawnPoints.pick_random()
	
	var objectNode = randomObject.instantiate()
	get_tree().current_scene.add_child(objectNode)
	objectNode.global_position = randomSpawnPoint.global_position
	
	_set_new_coin_spawn_line(randomSpawnPoint)

func _set_new_coin_spawn_line(objectPoint):
	if objectPoint != currentCoinSpawnLine:
		return
		
	var spawnSelection = spawnPoints.filter(func(point): return point != objectPoint)
	currentCoinSpawnLine = spawnSelection.pick_random()

func _set_coin():
	var coinNode = coin.instantiate()
	var spawnPoint = currentCoinSpawnLine.global_position

	get_tree().current_scene.add_child(coinNode)
	coinNode.global_position = spawnPoint
