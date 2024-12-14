extends CharacterBody2D

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D

@export var onMission = false
@export var baseHouse: Node2D

enum mission_states {PRODUCTION, STORAGE}

const SPEED = 100.0
const WOOD = preload("res://wood.tres")

var mission = mission_states.PRODUCTION
var targetTree
var doChop = false
var rawMaterial: Materials

func _physics_process(delta):
	if doChop and not targetTree:
		doChop = false
		_change_mission()
		onMission = false
		return
	elif doChop:
		velocity = Vector2.ZERO
		animated_sprite_2d.play("chop")
		return
	elif not onMission: 
		_get_new_mission()
		show()
	else:
		var next_path_position: Vector2 = navigation_agent_2d.get_next_path_position()
		velocity = global_position.direction_to(next_path_position) * SPEED
	
	_set_animation()

	move_and_slide()

func _get_new_mission():
	if mission == mission_states.PRODUCTION: 
		targetTree = _get_nearest_tree()
		rawMaterial = WOOD
		rawMaterial.quantity = 3
		navigation_agent_2d.target_position = targetTree.global_position
	else:
		navigation_agent_2d.target_position = baseHouse.global_position
		
	onMission = true
	
func _get_nearest_tree():
	var trees = get_tree().get_nodes_in_group("trees")
	var nearestDistance
	var selectedTree
	
	for tree in trees:
		var distance = global_position.distance_to(tree.global_position)
		if not nearestDistance or distance < nearestDistance: 
			nearestDistance = distance
			selectedTree = tree
	
	return selectedTree

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
	if mission == mission_states.PRODUCTION:
		_chop(targetTree)
	else:
		hide()
		baseHouse.add_material(rawMaterial)
		rawMaterial = null
		
		await get_tree().create_timer(1).timeout
		_change_mission()
		onMission = false
		show()

func _chop(tree):
	doChop = true
	tree.get_hit(animated_sprite_2d.scale.x)

func _on_animated_sprite_2d_animation_finished() -> void:
	if doChop: _chop(targetTree)
	
