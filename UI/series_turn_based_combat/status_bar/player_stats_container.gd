extends PanelContainer

@onready var name_label: Label = %Name
@onready var hp_2_label: Label = %HP2
@onready var mana_2_label: Label = %Mana2
@onready var over_drive_bar: ProgressBar = %OverDriveBar

var focusStyleBox = preload("res://focus_player_stats.tres")
var normalStyleBox :StyleBox = StyleBoxEmpty.new()
var characterResource: Resource
var oldCharacterResource: Resource
	
func _process(delta: float) -> void:
	var refreshed = _check_change_data()
	
	if refreshed: 
		_update_stats()
		oldCharacterResource = characterResource.duplicate()

func _check_change_data():
	var healthChanged = characterResource["currentHealth"] != oldCharacterResource["currentHealth"]
	var manaChanged = characterResource["currentMana"] != oldCharacterResource["currentMana"]
	var overDriveChanged = characterResource["overDriveValue"] != oldCharacterResource["overDriveValue"]
	
	if healthChanged or manaChanged or overDriveChanged:
		return true
	
	return false

func _update_stats() -> void:
	_refresh_animation(hp_2_label, characterResource["currentHealth"])
	_refresh_animation(mana_2_label, characterResource["currentMana"])
	_refresh_animation(over_drive_bar, characterResource["overDriveValue"])

func _refresh_animation(node: Control, newValue: int) -> void:
	var tween = get_tree().create_tween()
	
	if node is Label:
		var oldValue = int(node.text)
		tween.tween_method(tween_label.bind(node), oldValue, newValue, 0.3)
	elif node is ProgressBar:
		var oldValue = node.value
		tween.tween_method(tween_progress_bar.bind(node), oldValue, newValue, 0.3)
		
func tween_label(value: int, labelNode: Label):
	labelNode.text = str(value)
	
func tween_progress_bar(value: int, progressBarNode: ProgressBar):
	progressBarNode.value = value
	
func activate_focus() -> void:
	add_theme_stylebox_override("panel", focusStyleBox)
	
func deactivate_focus() -> void:
	add_theme_stylebox_override("panel", normalStyleBox)

func set_player_stats(newCharacterResource: Resource) -> void:
	characterResource = newCharacterResource
	
	var statusContainer = get_tree().get_first_node_in_group("turnBasedStatusContainer")
	
	name_label.text = characterResource["name"]
	hp_2_label.text = str(characterResource["currentHealth"])
	mana_2_label.text = str(characterResource["currentMana"])
	over_drive_bar.value = characterResource["overDriveValue"]

	oldCharacterResource = characterResource.duplicate()
