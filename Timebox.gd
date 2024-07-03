extends CSGCombiner3D

var player

const TimeEvent = preload("res://TimeEvent.gd")


func _ready():
	player =  $"../.."

func _on_area_3d_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index==MOUSE_BUTTON_LEFT :
		for brew in $Area3D.get_overlapping_areas():
			var tevent = TimeEvent.new()
			tevent.type = "Potion"
			tevent.variable=brew.get_parent().item
			brew.get_parent().queue_free()
			tevent.duration = $Label3D.times[$Label3D.index]
			tevent.pause()
			player.time_effects.append(tevent)
	pass # Replace with function body.
