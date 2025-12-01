extends Control

signal over_heated()
signal done()

@export var player: CharacterBody3D

@export var passivHeatReduce := 0.3
@export var passivHeatCooldown := 3.0
@export var reloadTime := 1.0
@export var shotsUntilOverheat := 15
@export var overheatPenalty := 1.0
@export var fullCooldownTime := 3.0

@onready var progress_bar: ProgressBar = $ProgressBar

const EVENT_BAR = preload("uid://3uqn5rgvjv6m")

var tween: Tween
var hasBonus = false

func _ready() -> void:
	player.shooted.connect(_on_player_shooted)

func _on_player_shooted():
	if hasBonus: return
		
	progress_bar.value += 100.0 / shotsUntilOverheat
	
	_set_progress_bar_color()
	
	if progress_bar.value == 100:
		_do_overheat()

func _set_progress_bar_color():
	var styleBox: StyleBoxFlat = progress_bar.get_theme_stylebox("fill")
	if progress_bar.value > 80:
		styleBox.bg_color = Color(1.0, 0.0, 0.0, 1.0)
	elif progress_bar.value > 60:
		styleBox.bg_color = Color(1.0, 0.737, 0.0, 1.0)
	else:
		styleBox.bg_color = Color(1.0, 1.0, 1.0, 1.0)

func _do_overheat():
	over_heated.emit()
	
	await get_tree().create_timer(overheatPenalty).timeout
	
	tween = create_tween()
	tween.tween_property(progress_bar, "value", 0, fullCooldownTime)
	
	var eventBar = EVENT_BAR.instantiate()
	
	eventBar.normal_done.connect(_on_event_bar_fail)
	eventBar.succsess_done.connect(_on_event_bar_done)
	eventBar.bonus_done.connect(_on_event_bar_bonus_done)
	eventBar.fail.connect(_on_event_bar_fail)
	
	progress_bar.add_child(eventBar)

func _on_event_bar_done() -> void:
	_reset()
	done.emit()

func _on_event_bar_bonus_done() -> void:
	_on_event_bar_done()
	
	hasBonus = true
	
	await get_tree().create_timer(2).timeout
	
	hasBonus = false

func _on_event_bar_fail() -> void:
	await tween.finished
	
	done.emit()

func _reset():
	progress_bar.value = 0
	progress_bar.get_child(0).queue_free()
	tween.stop()
	
func reload():
	var tween = create_tween()
	tween.tween_property(progress_bar, "value", 0, reloadTime)
	
	tween.finished.connect(done.emit)

func can_reload():
	return progress_bar.value > 0
