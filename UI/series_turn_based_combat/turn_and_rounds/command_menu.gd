extends Control
class_name CommandMenu

signal command_selected(command: Resource)

@onready var attack_button: Button = %AttackButton
@onready var skills_button: Button = %SkillsButton
@onready var run_button: Button = %RunButton

@onready var main_commands: VBoxContainer = %MainCommands
@onready var skill_container: GridContainer = $MarginContainer/ScrollContainer/SkillContainer

const COMMAND_BUTTON = preload("res://command_button.tscn")

const ATTACK = preload("res://Attack.tres")
var skills = [preload("res://heal.tres"), preload("res://slash.tres")]

func _ready() -> void:
	add_to_group("commandMenu")
	
	_set_late_signals()
	
	attack_button.pressed.connect(_on_command_pressed.bind(ATTACK))
	skills_button.pressed.connect(_on_skill_button_pressed)
	run_button.pressed.connect(_on_run_button_pressed)
	
	attack_button.grab_focus()

func _set_late_signals():
	await get_tree().current_scene.ready
	
	for character: TurnBasedAgent in get_tree().get_nodes_in_group("player"):
		character.player_turn_started.connect(_on_player_turn.bind(character))
		character.undo_command_selected.connect(_on_player_turn.bind(null))	

func _on_player_turn(character: TurnBasedAgent) -> void:
	if character: _set_command_options(character)
	show()
	main_commands.get_children()[0].grab_focus()

func _on_command_pressed(command: Resource):
	hide()

	command_selected.emit(command)
	
	main_commands.show()
	skill_container.hide()
	
	attack_button.grab_focus()

func _on_skill_button_pressed():
	main_commands.hide()
	skill_container.show()
	
	skill_container.get_children()[0].grab_focus()	

func _on_run_button_pressed():
	get_tree().quit()

func _set_command_options(character: TurnBasedAgent):
	if character.basicAttack: 
		attack_button.pressed.connect(_on_command_pressed.bind(character.basicAttack))
	else: attack_button.hide()

	if character.skills.is_empty(): skills_button.hide()
	else:
		
		for skill in skill_container.get_children():
			skill.queue_free()
			
		for skill in character.skills:
			var newCommandButton = COMMAND_BUTTON.instantiate()
			newCommandButton.text = skill.name
			newCommandButton.pressed.connect(_on_command_pressed.bind(skill))
			skill_container.add_child(newCommandButton)
		
		
		
