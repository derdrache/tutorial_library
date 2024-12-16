extends CharacterBody2D

signal character_selected

var movement = 2
var cellSize: Vector2

func _ready() -> void:
	add_to_group("character")
	_set_cell_size()

func _set_cell_size():
	await get_tree().current_scene.ready
	
	var grid = get_tree().get_first_node_in_group("grid")
	cellSize = Vector2(grid.cellWidth + grid.borderSize, grid.cellHeight + grid.borderSize)

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	var onLeftClicked :bool = event is InputEventMouseButton and event.button_index == 1 and event.is_pressed()
	if onLeftClicked: character_selected.emit(movement)

func move_to(positionSequence: Array):
	var startPosition = positionSequence.pop_front()
	
	for movePosition in positionSequence:
		var direction =  movePosition - startPosition
		
		var tween = get_tree().create_tween()
		tween.tween_property(self, "global_position", global_position + Vector2(direction) * cellSize, 0.75)
		await tween.finished
		
		startPosition = movePosition
	
