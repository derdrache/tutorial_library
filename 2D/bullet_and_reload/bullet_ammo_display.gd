extends HBoxContainer

@onready var bullet_display: HBoxContainer = %bulletDisplay
@onready var ammo_count_label: Label = %ammoCountLabel

func refresh_bullets(bulletCount):
	for child in bullet_display.get_children():
		var index = child.get_index()
		
		if index < bulletCount:
			child.modulate = Color.WHITE
		else:
			child.modulate = Color.BLACK

func refresh_ammo_count(ammoCount):
	ammo_count_label.text = str(ammoCount)
