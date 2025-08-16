extends CharacterBody2D
#class_name Monster

@export var monsterResource: MonsterResource

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var status_bar: Control = $StatusBar
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D

var speed = 50

func _ready() -> void:
	_set_model()
	
	_wait_and_set_move_point()
	
func _physics_process(delta: float) -> void:
	if navigation_agent_2d.target_position:
		var direction = global_position.direction_to(navigation_agent_2d.get_next_path_position())
		velocity = direction * speed

		move_and_slide()

func _set_model():
	sprite_2d.texture = monsterResource.get_current_monster()

func use_item(item:Item):
	if item.happiness > 0: 
		status_bar.change_happiness(item.happiness)
	elif item.hunger > 0:
		status_bar.change_hunger(item.hunger)

func _wait_and_set_move_point():
	var randomTime = randf_range(1,4)
	await get_tree().create_timer(randomTime).timeout
	
	var targetPoint: Vector2
	var items = get_tree().get_nodes_in_group("PickupItem")
	
	if items:
		targetPoint = items.pick_random().global_position
	else:
		targetPoint = NavigationServer2D.map_get_random_point(
			NavigationServer3D.get_maps()[0], 1, false)
		
	navigation_agent_2d.target_position = targetPoint

func _on_navigation_agent_2d_target_reached() -> void:
	navigation_agent_2d.target_position = Vector2.ZERO
	
	_wait_and_set_move_point()
