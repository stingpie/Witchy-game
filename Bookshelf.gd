extends Node3D

const dragitem = preload("res://dragItem.tscn")

func update_items(items):
	var iter = 0
	for item in items:
		var ditem = dragitem.instantiate()
		ditem.set_item(item, load("res://icon.svg"))
		$positions.get_child(iter).add_child(ditem)


func update_wands(wands):
	for i in range(min(4,len(wands))):
		for j in range(min(4,len(wands[i]))):
			var ditem = dragitem.instantiate()
			ditem.set_item(wands[i][j], load("res://icon.svg"))
			$positions.get_child(i*4+j).add_child(ditem)
