extends CharacterBody3D

signal turn_done()
signal died(character: Node3D)

var active = false
var canSelectTarget = false
var selectedTarget: Node3D

func _init() -> void:
	add_to_group("player")

func _ready() -> void:
	_set_signals()

func _set_signals():
	var commandMenu = get_tree().get_first_node_in_group("CommandMenu")
	commandMenu.command_selected.connect(_on_command_menu_command_selected)

func _on_command_menu_command_selected(commandType: CommandMenu.Command_Types):
	if not active: return

	match commandType:
		CommandMenu.Command_Types.ATTACK: _select_target()
		CommandMenu.Command_Types.DEFENSE: _do_defense()
		CommandMenu.Command_Types.RUN: _do_run()

func _select_target():
	canSelectTarget = true
	_select_new_target(0)

func _do_defense():
	# increase defense here
	await get_tree().process_frame
	_end_turn()

func _do_run():
	# run animation
	# change scene
	pass

func _input(_event: InputEvent) -> void:
	if not active or not canSelectTarget: return

	if Input.is_action_just_pressed("ui_left"):
		_select_new_target(-1)
	elif Input.is_action_just_pressed("ui_right"):
		_select_new_target(1)
	elif Input.is_action_just_pressed("ui_accept"):
		_do_attack(selectedTarget)
		_reset_target()

func _do_attack(enemy: Node3D):
	var startPosition = global_position
	var targetPosition = enemy.global_position
	
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", targetPosition, 0.5)
	
	# damage here
	
	tween.tween_property(self, "global_position", startPosition, 0.5)
	
	await tween.finished
	
	_end_turn()

func _end_turn():
	active = false
	turn_done.emit()

func _reset_target():
	canSelectTarget = false
	selectedTarget.set_select(false)
	selectedTarget = null


func set_active(boolean:bool):
	active = boolean

func _select_new_target(indexChange: int):
	var enemies = get_tree().get_nodes_in_group("enemy")
	var currentIndex = enemies.find(selectedTarget)
	
	currentIndex += indexChange
	
	if currentIndex < 0:
		currentIndex = enemies.size() - 1
	elif currentIndex > enemies.size() - 1:
		currentIndex = 0
	
	if selectedTarget:
		selectedTarget.set_select(false)
	
	selectedTarget = enemies[currentIndex]
	
	selectedTarget.set_select(true)
