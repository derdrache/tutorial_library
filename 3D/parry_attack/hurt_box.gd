extends Area3D

signal parried()

@onready var damage_indicator: Node3D = $damageIndicator
@onready var parry_timer: Timer = $parryTimer

@export var health:= 50

var openParryWindow = false
var canParry = false
var parryFail = false

func _ready() -> void:
	_set_signals()

func _input(event: InputEvent) -> void:
	if openParryWindow and Input.is_action_just_pressed("shift"):
		canParry = true
	elif openParryWindow and not Input.is_action_just_pressed("shift"):
		parryFail = true

func _set_signals():
	for enemy in get_tree().get_nodes_in_group("enemy"):
		enemy.parry_window_opened.connect(_on_parry_window_opened)
	
	parry_timer.timeout.connect(_on_parry_timer_timeout)
	
func _on_parry_window_opened():
	openParryWindow = true
	
	parry_timer.start()

func take_damage(damage: int, attacker:CharacterBody3D):
	if canParry and not parryFail: 
		parried.emit()
		attacker.got_parried()
		return
		
	damage_indicator.create_indicator_label(-damage)
	
	health -= damage
	health = clamp(health, 0, 50)

func _on_parry_timer_timeout() -> void:
	openParryWindow = false
	canParry = false
	parryFail = false
