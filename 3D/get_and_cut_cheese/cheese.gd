extends CharacterBody3D

@onready var model: Node3D = $model

const FOOD_INGREDIENT_CHEESE_CHOPPED = preload("res://assets/kitchen prototype/food_ingredient_cheese_chopped.gltf")
const FOOD_INGREDIENT_CHEESE_SLICE = preload("res://assets/kitchen prototype/food_ingredient_cheese_slice.gltf")

var cutModels = [FOOD_INGREDIENT_CHEESE_CHOPPED, FOOD_INGREDIENT_CHEESE_SLICE]

var cuts = 0
var maxCuts = 2

func cut():
	if cuts == maxCuts: return
	cuts += 1
	
	_change_model(cutModels[cuts -1])
	
func _change_model(newModel):
	for node in model.get_children():
		node.queue_free()
		
	model.add_child(newModel.instantiate())
