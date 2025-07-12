extends StaticBody2D

@export var monsterResource: MonsterResource

@onready var sprite_2d: Sprite2D = $Sprite2D

const MONSTER = preload("res://prepare/tamagotchi_serie/part2/monster.tscn")

var doShake = true
var isOpen = false

func _ready() -> void:
	_set_model()
	
func _set_model():
	sprite_2d.texture = monsterResource.eggModel

func _physics_process(delta: float) -> void:
	if doShake: _shake()

func _shake():	
	var offset = Vector2(randi_range(-2, 2), randi_range(-2, 2))
	
	sprite_2d.offset = offset


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_just_pressed("leftClick") and not isOpen:
		_open_egg()

func _open_egg():
	doShake = false
	
	var tween = create_tween()
	tween.tween_property(sprite_2d, "rotation_degrees", 720, 1)
	tween.parallel()
	tween.tween_property(sprite_2d, "scale", Vector2(0.05, 0.05), 1)
	
	await tween.finished
	
	_spawn_monster()

	queue_free()

func _spawn_monster():
	var monsterNode = MONSTER.instantiate()
	monsterNode.monsterResource = monsterResource
	get_tree().current_scene.add_child(monsterNode)
	monsterNode.global_position = global_position
