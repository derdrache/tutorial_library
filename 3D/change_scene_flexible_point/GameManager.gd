extends Node

enum Area_Type {AREA1, AREA2, HOUSE}

var areaDict = {
	Area_Type.AREA1: "res://scene.tscn",
	Area_Type.AREA2: "res://scene2.tscn",
	Area_Type.HOUSE: "res://house_inside.tscn"
}

var lastArea: Area_Type

func change_area(currentArea: Area_Type):
	lastArea = currentArea
