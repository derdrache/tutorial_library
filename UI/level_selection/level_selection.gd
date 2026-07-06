extends Control

@onready var level_container_box: GridContainer = %LevelContainerBox
@onready var dot_indicator_box: HBoxContainer = %dotIndicatorBox

const DOT_INDICATOR = preload("uid://d10cqvtw8vu64")

const LEVEL_PER_PAGE = 10

# Simplified form of stored level information
var levelList = [
	{"unlocked": true, "done": true},
	{"unlocked": true, "done": true},
	{"unlocked": true, "done": true},
	{"unlocked": true, "done": true},
	{"unlocked": true, "done": true},
	{"unlocked": true, "done": false},
	{"unlocked": false, "done": false},
	{"unlocked": false, "done": false},
	{"unlocked": false, "done": false},
	{"unlocked": false, "done": false},
	{"unlocked": false, "done": false},
	{"unlocked": false, "done": false},
	{"unlocked": false, "done": false},
	{"unlocked": false, "done": false},
	{"unlocked": false, "done": false},
	{"unlocked": false, "done": false},
	{"unlocked": false, "done": false},
	{"unlocked": false, "done": false},
	{"unlocked": false, "done": false},
	{"unlocked": false, "done": false},
	{"unlocked": false, "done": false},
	{"unlocked": false, "done": false},
	{"unlocked": false, "done": false},
	{"unlocked": false, "done": false},
	{"unlocked": false, "done": false},
	{"unlocked": false, "done": false},
	{"unlocked": false, "done": false},
	{"unlocked": false, "done": false},
	{"unlocked": false, "done": false},
	{"unlocked": false, "done": false},
	{"unlocked": false, "done": false},
	{"unlocked": false, "done": false},
	{"unlocked": false, "done": false},
	{"unlocked": false, "done": false},
	{"unlocked": false, "done": false},
	{"unlocked": false, "done": false},
	{"unlocked": false, "done": false},
	{"unlocked": false, "done": false},
]
var levelCount: int = levelList.size()
var pageCount := 1
var currentPage = 0:
	set(value):
		if value < 0 or value > pageCount - 1:
			return
			
		currentPage = value

func _ready() -> void:	
	_set_page_count()
	
	_set_dot_indicator()
	
	_refresh()

func _set_page_count():
	pageCount = ceil(levelCount / 10.0)

func _set_dot_indicator():
	for i in pageCount:
		var dotIndicatorNode = DOT_INDICATOR.instantiate()
		dot_indicator_box.add_child(dotIndicatorNode)
	
	_change_dot_indicator()

func _change_dot_indicator():
	for i in dot_indicator_box.get_child_count():
		var isActive = i == currentPage
		dot_indicator_box.get_child(i).active = isActive

func _refresh():
	_refresh_level_container()
	
	_change_dot_indicator()

func _refresh_level_container():
	var pageLevels: int = levelCount - currentPage * 10
	
	if pageLevels > LEVEL_PER_PAGE:
		pageLevels = LEVEL_PER_PAGE
	
	for i in level_container_box.get_child_count():
		var available = i <= pageLevels - 1
		var levelContainer = level_container_box.get_child(i)
		
		if not available:
			levelContainer.modulate.a = 0
			continue 
		
		levelContainer.modulate.a = 1
		
		var levelIndex = currentPage * LEVEL_PER_PAGE + i
		levelContainer.levelNumber = levelIndex + 1
		
		if levelList[levelIndex].done:
			levelContainer.set_done()
		elif levelList[levelIndex].unlocked:
			levelContainer.set_open()
		else:
			levelContainer.set_lock()

func _on_back_button_pressed() -> void:
	currentPage -= 1
	_refresh()

func _on_next_button_pressed() -> void:
	currentPage += 1
	_refresh()
	



	
	
