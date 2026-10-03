extends Node2D

@export var loot_items: Array[Item]

const ITEM_SCENE = preload("uid://dh1pawb7d1icu")
const RANGE = 20

func get_loot() -> Item:
	var tierItemList = {
		"common": _get_tier_list(Item.COMMON),
		"rare": _get_tier_list(Item.RARE),
		"epic": _get_tier_list(Item.EPIC),
	}
	var randomNumber := randi_range(0, 100)
	
	if randomNumber <= 10:
		return tierItemList["epic"].pick_random()
	elif randomNumber <= 40:
		return tierItemList["rare"].pick_random()
	else:
		return tierItemList["common"].pick_random()

func _get_tier_list(tierLevel):
	var items = []
	
	for item in loot_items:
		if item.tierLevel == tierLevel:
			items.append(item)
	
	return items

func throw_loot():
	var randomLoot = get_loot()
	
	var lootScene = ITEM_SCENE.instantiate()
	lootScene.loot = randomLoot

	get_tree().current_scene.add_child(lootScene)
	
	lootScene.global_position = get_parent().global_position

	var spawnDirection = Vector2(randf_range(-1, 1), randf_range(-1, 1))

	var tween = create_tween()
	tween.tween_property(lootScene, "global_position", global_position + spawnDirection * RANGE, 0.2)
