extends CanvasLayer

@export var expGain = 55 
@export var animationTime := 2.0

@onready var grid_container: GridContainer = %GridContainer

const CHARACTER_RESULT_CONTAINER = preload("res://character_result_container.tscn")

var isDone = false
var players = [
	load("res://player1.tres"),
	load("res://player2.tres")
]

func _input(event: InputEvent) -> void:
	var isKeyPressed = event.is_pressed() and event is InputEventKey
	if isKeyPressed and isDone:
		_done()
		
func _ready() -> void:	
	_create_result_screen()

func _create_result_screen():
	for character: CharacterResource in players:
		var characterResultContainer = CHARACTER_RESULT_CONTAINER.instantiate()
		characterResultContainer.expGain = expGain
		characterResultContainer.characterResource = character
		characterResultContainer.animationTime = animationTime
		
		grid_container.add_child(characterResultContainer)

func _done():
	pass
	# do what you want
