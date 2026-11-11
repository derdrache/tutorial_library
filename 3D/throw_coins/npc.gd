extends CharacterBody3D

@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var animation_player: AnimationPlayer = $Barbarian/AnimationPlayer

const SPEED = 5.0

var coinThrowNode: Node3D
var onAction = false

func _ready() -> void:
	add_to_group("npc")

func _physics_process(_delta: float) -> void:
	if not coinThrowNode or onAction:
		return
		
	var nextPosition = navigation_agent_3d.get_next_path_position()
	
	velocity = global_position.direction_to(nextPosition) * SPEED
	velocity.y = 0
	
	look_at(global_position + velocity, Vector3.UP, true)
	
	if not onAction:
		animation_player.play("Walking_A")
	
	move_and_slide()

func go_to_coin(coin):
	navigation_agent_3d.target_position = coin.global_position

func _pick_up_coins():
	onAction = true
	
	animation_player.play("PickUp")
	await animation_player.animation_finished
	
	var randomCoin = coinThrowNode.get_random_coin()
	navigation_agent_3d.target_position = randomCoin.global_position
	
	onAction = false

func _on_navigation_agent_3d_target_reached() -> void:
	_pick_up_coins()
