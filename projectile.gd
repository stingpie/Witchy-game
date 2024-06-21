extends CharacterBody3D

func _hit_building(area): #area is the Area2D of the building
	print("player hit building")

var damage =10
var made_by;

func _physics_process(delta):

	move_and_slide()


func _on_area_3d_body_entered(body):
	
	if body is CharacterBody3D and body != made_by :
		body.damage(damage)
	pass # Replace with function body.
