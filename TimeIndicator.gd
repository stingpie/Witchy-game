extends Label3D

const times = [15, 30, 45, 60, 90, 120, 180]
var index = 0

func _on_area_3d_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index==MOUSE_BUTTON_LEFT :
		index = (index+1) % len(times)
		text = str(times[index])
	pass # Replace with function body.
