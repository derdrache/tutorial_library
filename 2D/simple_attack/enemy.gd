extends CharacterBody2D

@onready var damage_label_indicator: Control = $DamageLabelIndicator

func take_damage(damage):
	damage_label_indicator.show_damage_label(damage)
