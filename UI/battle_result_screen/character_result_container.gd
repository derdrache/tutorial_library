extends PanelContainer

@export var characterResource: CharacterResource
@export var expGain: int

@onready var name_label: Label = %NameLabel
@onready var level_label: Label = %LevelLabel
@onready var exp_gain_label: Label = %ExpGainLabel
@onready var exp_bar: ProgressBar = %ExpBar
@onready var exp_net_level_label: Label = %ExpNetLevelLabel

var tween = create_tween()
var animationTime: float


func _ready() -> void:
	_set_data()

	await _result_animation()
	
	characterResource.get_exp(expGain)

func _set_data():
	name_label.text = characterResource.name
	level_label.text = str(characterResource.level)
	exp_gain_label.text = str(expGain)
	exp_net_level_label.text = str(characterResource.get_exp_for_next_level() - characterResource.currentExp)
	exp_bar.max_value = characterResource.get_exp_for_next_level()
	exp_bar.value = characterResource.currentExp
	
func _result_animation():
	tween.tween_method(_on_count_down, 0, expGain, animationTime)
	
	await tween.finished
	
func _on_count_down(value):
	var currentExp = characterResource.get_exp_for_next_level() - characterResource.currentExp - value

	if currentExp == 0:
		currentExp = characterResource.get_exp_for_next_level()
		_level_up()
	
	exp_gain_label.text = str(expGain - value)
	exp_net_level_label.text = str(currentExp)
	exp_bar.value = characterResource.currentExp + value - characterResource.get_exp_for_current_level()
	
func _level_up():
	characterResource.level_up()
	level_label.text = str(characterResource.level)
	
	# short pause to show increase the level up effect
	tween.pause()
	await get_tree().create_timer(0.5).timeout
	tween.play()
