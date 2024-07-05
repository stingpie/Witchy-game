extends Node3D

const dragitem = preload("res://dragItem.tscn")

func update_items(items):
	var iter = 0
	for item in items:
		var ditem = dragitem.instantiate()
		ditem.set_item(item)#, load("res://graphics/GUI/Potion_Bottle_HOLE_MASK.png"))
		$positions.get_child(iter).add_child(ditem)
		iter +=1


func update_wands(wands):
	for i in range(min(4,len(wands))):
		for j in range(min(4,len(wands[i]))):
			var ditem = dragitem.instantiate()
			ditem.set_item(wands[i][j])#, load("res://graphics/GUI/Potion_Bottle_HOLE_MASK.png"))
			$positions.get_child(i*4+j).add_child(ditem)

func clear():
	for i in range(min(16,$positions.get_child_count())):
		if($positions.get_child(i).get_child_count()>0 and  $positions.get_child(i).get_child(0)):
			for child in $positions.get_child(i).get_children():
				child.queue_free()
