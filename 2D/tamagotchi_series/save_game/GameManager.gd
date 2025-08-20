extends Node

var monsterList: Array[MonsterResource] = [
	preload("res://tamagotchi/monster_resource/fire_pig.tres"),
]
var foodItems: Array[Item] = [
	preload("res://tamagotchi/item_resource/banana.tres")
]
var toyItems: Array[Item] = [
	preload("res://tamagotchi/item_resource/ballon.tres")
]

var shopItems = [
	preload("res://tamagotchi/item_resource/fruit2.tres"),
	preload("res://tamagotchi/item_resource/glasses.tres"),
	preload("res://tamagotchi/item_resource/green_egg.tres"),
	preload("res://tamagotchi/item_resource/purple_egg.tres")
]

var activeMonster = monsterList.pop_front()

func _ready() -> void:
	load_data()

func bought_item(item: Item):
	shopItems.erase(item)
	
	if item.monsterResource:
		monsterList.append(item.monsterResource)
	elif item.hunger > 0:
		foodItems.append(item)
	elif item.happiness > 0:
		toyItems.append(item)

	save_data()

func change_monster(newMonster: MonsterResource):
	monsterList.erase(newMonster)
	monsterList.append(activeMonster)
	activeMonster = newMonster

func save_data():
	var fullMonsterList = monsterList + [activeMonster]
	var gameData = {
		"shopItems": shopItems.map(func(resource: Resource): return resource.resource_path),
		"foodItems": foodItems.map(func(resource: Resource): return resource.resource_path),
		"toyItems": toyItems.map(func(resource: Resource): return resource.resource_path),
		"monsterList": fullMonsterList.map(func(resource: Resource): return resource.get_save_data())
	}
	
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var json_string = JSON.stringify(gameData)
	save_file.store_line(json_string)

func load_data():
	if not FileAccess.file_exists("user://savegame.save"):
		return 
	
	var save_file = FileAccess.open("user://savegame.save", FileAccess.READ)
	var json = JSON.new()
	
	var gameData = JSON.parse_string(save_file.get_line())
	
	shopItems = []
	gameData["shopItems"].map(func(path): shopItems.append(load(path)))
	
	foodItems = []
	gameData["foodItems"].map(func(path): foodItems.append(load(path)))
	
	toyItems = []
	gameData["toyItems"].map(func(path): toyItems.append(load(path)))
	
	monsterList = []
	for monsterData in gameData["monsterList"]:
		var monsterResource = load(monsterData.path)
		monsterResource.load_data(monsterData)
		monsterList.append(monsterResource)
		
	activeMonster = monsterList.pop_back()
	
	
	
