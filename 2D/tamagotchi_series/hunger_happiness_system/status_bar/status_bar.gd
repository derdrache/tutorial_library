extends Control

@onready var happiness_bar: ProgressBar = $VBoxContainer/Happiness/ProgressBar
@onready var hunger_bar: ProgressBar = $VBoxContainer/Hunger/ProgressBar
@onready var happiness_timer: Timer = $HappinessTimer
@onready var hunger_timer: Timer = $HungerTimer

var monsterResource:MonsterResource

func _ready() -> void:
	monsterResource = get_parent().monsterResource
	_refresh_happiness()
	_refresh_hunger()

func _refresh_happiness():
	happiness_bar.value = monsterResource.happiness
	
func _refresh_hunger():
	hunger_bar.value = monsterResource.hunger


func _on_happiness_timer_timeout() -> void:
	change_happiness(-5)

func _on_hunger_timer_timeout() -> void:
	change_hunger(-5)

func change_happiness(changeValue: int):
	monsterResource.happiness += changeValue
	monsterResource.happiness = clamp(monsterResource.happiness, 0, 100)
	
	_refresh_happiness()
	
func change_hunger(changeValue: int):
	monsterResource.hunger += changeValue
	monsterResource.hunger = clamp(monsterResource.hunger, 0, 100)
	
	_refresh_hunger()
