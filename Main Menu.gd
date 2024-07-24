extends Node2D

const GAME_SCENE_PATH ="res://level1.tscn"
#var game_scene

var intro_playing=0

func _ready():
	ResourceLoader.load_threaded_request(GAME_SCENE_PATH)
	print("?")

func _process(delta):
	if Input.is_action_just_pressed("left click"):
		$MenuClickSFX.play()
	
	if(intro_playing>0):
		if(intro_playing>=4):
			$AnimatedSprite2D.visible=false
			$AnimatedSprite2D.pause()
			intro_playing = 0
		else:
			$AnimatedSprite2D.visible=true
			$AnimatedSprite2D.play("intro"+str(intro_playing))
		


func _on_quit_pressed():
	if(intro_playing==0):
		get_tree().quit()
	else:
		intro_playing+=1
	pass # Replace with function body.


func _on_options_pressed():
	pass # Replace with function body.


func _on_play_pressed():
	if(intro_playing==0):
		var game_scene = ResourceLoader.load_threaded_get(GAME_SCENE_PATH)
		get_tree().change_scene_to_packed(game_scene)
	else:
		intro_playing+=1
	pass # Replace with function body.


func _on_intro_pressed():
	if(intro_playing==0):
		intro_playing=1
	else:
		intro_playing+=1
	pass # Replace with function body.

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.pressed and intro_playing>0:
			intro_playing+=1
