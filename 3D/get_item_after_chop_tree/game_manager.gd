extends Node

signal item_received()

var inventory: Array[ItemBundle] = []

func add_item_to_inventory(newItemBundle: ItemBundle):	
	for itemBundle: ItemBundle in inventory:
		if itemBundle.item == newItemBundle.item:
			itemBundle.quantity += itemBundle.quantity
			item_received.emit(itemBundle)
			return
	
	inventory.append(newItemBundle)
	item_received.emit(newItemBundle)
