extends CharacterBody2D

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D

@export var onMission = false

enum mission_states {PRODUCTION, STORAGE}

const SPEED = 100.0

var mission = mission_states.PRODUCTION

func _physics_process(delta):
	if not onMission: 
		_get_new_mission()
		show()
	else:
		var next_path_position: Vector2 = navigation_agent_2d.get_next_path_position()
		velocity = global_position.direction_to(next_path_position) * SPEED
	
	_set_animation()

	move_and_slide()

func _get_new_mission():
		var possibleHouses: Array
		
		if mission == mission_states.PRODUCTION: 
			possibleHouses = get_tree().get_nodes_in_group("production_house")
		else:
			possibleHouses = get_tree().get_nodes_in_group("storage_house")
		
		var randomHouse = possibleHouses.pick_random()
		navigation_agent_2d.target_position = randomHouse.global_position
		onMission = true

func _set_animation():
	if velocity.x < 0: animated_sprite_2d.flip_h = true
	elif velocity.x > 0: animated_sprite_2d.flip_h = false
	
	if velocity:
		animated_sprite_2d.play("run")
	else:
		animated_sprite_2d.play("idle")

func _change_mission():
	if mission == mission_states.PRODUCTION: mission = mission_states.STORAGE
	else: mission = mission_states.PRODUCTION

func _on_navigation_agent_2d_target_reached() -> void:
	hide()
	
	await get_tree().create_timer(1).timeout
	
	_change_mission()
	
	onMission = false
