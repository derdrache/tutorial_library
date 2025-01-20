extends TextureRect

@export var icon: CompressedTexture2D
@export var cooldownTime: float = 2

@onready var cooldown_timer: Timer = %CooldownTimer
@onready var cooldown_container: PanelContainer = %CooldownContainer
@onready var cooldown_count_label: Label = %CooldownCountLabel

func _ready() -> void:
	texture = icon
	cooldown_timer.wait_time = cooldownTime
	cooldown_container.hide()

func _on_gui_input(event: InputEvent) -> void:
	var isLeftClicked = event is InputEventMouseButton and event.button_index == 1 and event.is_pressed()
	
	if isLeftClicked: _start_cooldown()

func _start_cooldown():
	if cooldown_timer.time_left: return
	
	cooldown_timer.start()
	cooldown_container.show()

func _on_cooldown_timer_timeout() -> void:
	cooldown_container.hide()

func _process(delta: float) -> void:
	if cooldown_timer.time_left:
		var roundCooldown = round(cooldown_timer.time_left)
		if roundCooldown == 0: roundCooldown = 1
		cooldown_count_label.text = str(roundCooldown)
