extends CSGCombiner3D



var contents = []


var recipies =[]
@export_file var file = "res://recipies.json"
const item_schema = preload("res://dragItem.tscn")
@onready var cam = $"../../Camera3D"

func _ready():
	var f = FileAccess.open(file, FileAccess.READ)
	var json_string = f.get_as_text()
	var json = JSON.new()
	var error = json.parse(json_string)
	if error == OK:
		var data_received = json.data
		if typeof(data_received) == TYPE_ARRAY:
			recipies = data_received
		else:
			print("Unexpected data")
	else:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
	f.close()


func _on_dropzone_area_entered(area):
	if area.get_parent().name == "DragItem":
		contents.append(area.get_parent().item)
		area.get_parent().is_dragged = false
		area.get_parent().position= Vector3(0,0,0)
		area.get_parent().get_node("Sprite3D").no_depth_test=false
	
	pass # Replace with function body.


func _on_faucet_input_event(camera, event, position, normal, shape_idx):
	if event.is_action_pressed("left click"):
		#print(contents)
		for recipe in recipies:
			#print(recipe)
			if(arrays_have_same_content(recipe['ingredients'], contents)):
				print(":)")
				var item = item_schema.instantiate()
				item.set_item(recipe['result'], load("res://icon.svg"))
				
				item.cam = cam
				item.position=(global_position - $"../Bookshelf right/positions/p 1".global_position) 
				item.position.z=0
				item.get_node("Sprite3D").position.z=0.5
				item.get_node("Sprite3D").no_depth_test=true
				item.get_node("Area3D/CollisionShape3D").shape.size.z=1
				
				
				$"../Bookshelf right/positions/p 1".add_child(item)
				pass
		contents=[]
	pass # Replace with function body.


func arrays_have_same_content(array1, array2):
	if array1.size() != array2.size(): return false
	for item in array1:
		if !array2.has(item): return false
		if array1.count(item) != array2.count(item): return false
	return true
