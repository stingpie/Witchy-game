extends Node2D

var game_scene = preload("res://testmap.tscn")



var intro_playing=0

func _process(delta):
	
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
		if event.pressed:
			intro_playing+=1
