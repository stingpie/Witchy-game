extends CharacterBody3D

func _hit_building(area): #area is the Area2D of the building
	print("player hit building")

var damage =10

func _physics_process(delta):

	move_and_slide()


func _on_area_3d_body_entered(body):
	
	if body.name.to_lower().substr(0,5) == "enemy":
		body.damage(damage)
	pass # Replace with function body.
