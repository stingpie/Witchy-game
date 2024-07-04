extends Node3D



@export_file var file
@export_file var sprite

var dialog

func _ready():
	
	var f = FileAccess.open(file, FileAccess.READ)
	var json_string = f.get_as_text()
	var json = JSON.new()
	var error = json.parse(json_string)
	if error == OK:
		var data_received = json.data
		if typeof(data_received) == TYPE_ARRAY:
			dialog = data_received
		else:
			print("Unexpected data")
	else:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
	f.close()
	
	$AnimatedSprite3D.sprite_frames.add_animation("idle")
	$AnimatedSprite3D.sprite_frames.add_frame("idle", load(sprite))
	$AnimatedSprite3D.play("idle")

func _physics_process(delta):
	
	if $"../Player/PlayerBody3D" in $"Area3D".get_overlapping_bodies():
		if Input.is_action_just_pressed("interact") and $"../Player/PlayerBody3D/Camera3D/Dialog".is_closed():
			if(typeof(dialog[0])==TYPE_STRING):
				$"../Player/PlayerBody3D/Camera3D/Dialog".dialog = dialog
				$"../Player/PlayerBody3D/Camera3D/Dialog".begin(delta)
			else:
				for conv in dialog:
					if(len(conv['cond'])==0):
						for result in conv["result"]:
							if result[0]=="[":
								$"../Player/PlayerBody3D".tags.append(result)
							elif result[0].begins_with("get_potion"):
								$"../Player/PlayerBody3D".inventory[" ".join(result.split(" ").slice(2))] = int(result.split(" ")[1])
						
						$"../Player/PlayerBody3D".pause()
						$"../Player/PlayerBody3D/Camera3D/Dialog".dialog = conv["dialog"]
						$"../Player/PlayerBody3D/Camera3D/Dialog".begin(delta)
					else:
						var to_remove={}
						var are_requirements_met=true
						for condition in conv["cond"]:
							var inv=false;
							var truth=false;
							if(condition.begins_with("not")):
								inv=true;
								condition = condition.substr(4)
								
							if(condition.begins_with("give")):
								if(" ".join(condition.split(" ").slice(2)) in $"../Player/PlayerBody3D".inventory):
									if($"../Player/PlayerBody3D".inventory[" ".join(condition.split(" ").slice(2))]<= int(condition.split(" ")[1])):
										to_remove[" ".join(condition.split(" ").slice(2))] = int(condition.split(" ")[1])
										truth = true
									
										
							elif(condition[0]=="["):
								if(condition in $"../Player/PlayerBody3D".tags):
									truth = true 
							if(not (truth and not inv or not truth and inv)):
								are_requirements_met=false
								break

						
						if(are_requirements_met):
							for item in to_remove:
								$"../Player/PlayerBody3D".inventory[item] -= to_remove[item]
								if $"../Player/PlayerBody3D".inventory[item]==0:
									$"../Player/PlayerBody3D".inventory.erase(item)
								#print($"../Player/PlayerBody3D".inventory[item], " ", item, ":", to_remove[item])
							
							for result in conv["result"]:
								if result[0]=="[":
									$"../Player/PlayerBody3D".tags.append(result)
								elif result.begins_with("get_potion"):
									$"../Player/PlayerBody3D".inventory[" ".join(result.split(" ").slice(2))] = int(result.split(" ")[1])
							
							$"../Player/PlayerBody3D".pause()
							$"../Player/PlayerBody3D/Camera3D/Dialog".dialog = conv["dialog"]
							$"../Player/PlayerBody3D/Camera3D/Dialog".begin(delta)
							break
