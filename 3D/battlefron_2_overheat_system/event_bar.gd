extends TextureRect

signal normal_done()
signal bonus_done()
signal succsess_done()
signal fail()

@export var duration: float = 1.0

@onready var indicator: TextureRect = $Indicator

var xEndPosition: float
var bonusRangeX = Vector2(25, 44)
var fastRangeX = Vector2(93, 124)

func _ready() -> void:
	xEndPosition = global_position.x - indicator.size.x / 2
	
	start()

func start():
	var endCenterOffSet = Vector2(size.x, size.y / 2)
	var indicatorCenterOffSet = indicator.size/2
	
	indicator.global_position = global_position + endCenterOffSet - indicatorCenterOffSet

func _process(delta: float) -> void:
	indicator.global_position.x -= size.x / duration * delta
	
	if indicator.global_position.x < xEndPosition:
		_finish(true)

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("actionR"):
		_finish()

func _finish(normalDone = false):
	set_process(false)

	if normalDone: 
		normal_done.emit()
	else:
		var inBonusRange = _in_range(bonusRangeX)
		var inFastRange = _in_range(fastRangeX)
		
		if inBonusRange:
			bonus_done.emit()
		elif inFastRange:
			succsess_done.emit()
		else:
			fail.emit()
		
	queue_free() 

func _in_range(eventRange: Vector2):
	var indicatorPosition = indicator.global_position.x + indicator.size.x / 2 - global_position.x
	
	if indicatorPosition >= eventRange.x and indicatorPosition <= eventRange.y:
		return true
	else:
		return false
	
	
	
	
