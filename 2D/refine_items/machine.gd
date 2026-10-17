extends StaticBody2D

@export var usableItems: Array[Resource] = []
@export var productionItems: Array[Resource] = []

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var item_scene: StaticBody2D = $ItemScene
@onready var timer: Timer = $Timer

var currentItem: Resource
var isDone = false

func _ready() -> void:
	add_to_group("machine")
	item_scene.hide()

func can_use(item: Resource):
	return not currentItem and item in usableItems

func put_usable_item(item: Resource):
	currentItem = item
	
	timer.start()
	animation_player.play("start")

func get_production_item():
	if not isDone:
		return
	
	var currentItemIndex = usableItems.find(currentItem)
	
	isDone = false
	item_scene.reset()
	currentItem = null
	
	return productionItems[currentItemIndex]

func _on_timer_timeout() -> void:
	isDone = true
	var currentItemIndex = usableItems.find(currentItem)
	item_scene.item = productionItems[currentItemIndex]
	item_scene.show()
	animation_player.stop()
