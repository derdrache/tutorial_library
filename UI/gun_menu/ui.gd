extends Control

signal weapon_changed(weaponSelection: int)

@onready var ammo_label: Label = %AmmoLabel
@onready var weapon_texture_rect: TextureRect = %weaponTextureRect
@onready var progress_bar: ProgressBar = %ProgressBar
@onready var weapon_selection_container: HBoxContainer = %WeaponSelectionContainer

var weapons = [
	{"texture": "res://weapon1.png", "currentMagazine": 5, "magazine": 30, "ammo": 120},
	{"texture": "res://weapon2.png", "currentMagazine": 10, "magazine": 15, "ammo": 60},
	{"texture": "res://weapon3.png", "currentMagazine": -1, "magazine": 0, "ammo": 0},
]
var weaponSelection := 0

func _ready() -> void:
	_set_weapons()

	_refresh()
	
func _set_weapons():
	for i in weapon_selection_container.get_child_count():
		weapon_selection_container.get_child(i).texture = load(weapons[i].texture)

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("interaction"):
		_change_weapon()

func _change_weapon():
	var maxWeapons = weapon_selection_container.get_child_count()
	weaponSelection = wrap(weaponSelection + 1, 0, maxWeapons)
	
	_refresh()
	
	weapon_changed.emit(weaponSelection)

func _refresh():
	for i in weapon_selection_container.get_child_count():
		weapon_selection_container.get_child(i).selected = i == weaponSelection
		
	_set_ammo_label()
	
	_refresh_progress_bar()
	
	weapon_texture_rect.texture = weapon_selection_container.get_child(weaponSelection).get_texture()

func _set_ammo_label():
	var currentWeapon = weapons[weaponSelection]
	
	if currentWeapon.currentMagazine < 0:
		ammo_label.text = ""
	else:
		ammo_label.text = str(currentWeapon.currentMagazine) + " / " + str(currentWeapon.ammo)

func _refresh_progress_bar():
	var currentWeapon = weapons[weaponSelection]
	
	progress_bar.value = float(currentWeapon.currentMagazine)
	progress_bar.max_value = float(currentWeapon.magazine)

func update():
	_refresh()
