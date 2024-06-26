extends Node3D



@export_file var file

var dialog

func _ready():
	
	var f = FileAccess.open(file, FileAccess.READ)
	var json_string = f.get_as_text()
	var json = JSON.new()
	var error = json.parse(json_string)
	if error == OK:
		var data_received = json.data
		if typeof(data_received) == TYPE_ARRAY:
			print(data_received) # Prints array
			dialog = data_received
		else:
			print("Unexpected data")
	else:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
	f.close()


func _physics_process(delta):
	
	if $"../Player/PlayerBody3D" in $"Area3D".get_overlapping_bodies():
		if Input.is_action_just_pressed("interact"):
			$"../Player/PlayerBody3D/Camera3D/Dialog".dialog = dialog
			$"../Player/PlayerBody3D/Camera3D/Dialog".begin(delta)
	
