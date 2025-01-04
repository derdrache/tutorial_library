extends Control
class_name CommandMenu

signal command_selected(command: Resource)

@onready var attack_button: Button = %AttackButton
@onready var skills_button: Button = %SkillsButton
@onready var run_button: Button = %RunButton

@onready var main_commands: VBoxContainer = %MainCommands
@onready var skill_container: GridContainer = $MarginContainer/ScrollContainer/SkillContainer

const COMMAND_BUTTON = preload("res://turt_based_combat_series/command_menu/command_button.tscn")

const ATTACK = preload("res://Attack.tres")
var skills = [preload("res://heal.tres"), preload("res://slash.tres")]

func _ready() -> void:
	add_to_group("commandMenu")
	
	attack_button.pressed.connect(_on_command_pressed.bind(ATTACK))
	skills_button.pressed.connect(_on_skill_button_pressed)
	run_button.pressed.connect(_on_run_button_pressed)
	
	attack_button.grab_focus()
	
	_set_skill_commands()
	
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

func _set_skill_commands():
	for skill in skills:
		var newSkillNode = COMMAND_BUTTON.instantiate()
		newSkillNode.text = skill.name
		newSkillNode.pressed.connect(_on_command_pressed.bind(skill))
		skill_container.add_child(newSkillNode)
		
		
		
		
