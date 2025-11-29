extends Control
class_name CommandMenu

signal command_selected(commandType: Command_Types)

enum Command_Types {ATTACK, DEFENSE, RUN}

func _init() -> void:
	add_to_group("CommandMenu")
	hide()

func _on_attack_button_pressed() -> void:
	command_selected.emit(Command_Types.ATTACK)
	hide()

func _on_defense_button_pressed() -> void:
	command_selected.emit(Command_Types.DEFENSE)
	hide()

func _on_run_button_pressed() -> void:
	command_selected.emit(Command_Types.RUN)
	hide()


func _on_visibility_changed() -> void:
	if visible:
		%CommandContainer.get_child(0).grab_focus()
