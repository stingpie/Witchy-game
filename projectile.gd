extends CharacterBody3D

func _hit_building(area): #area is the Area2D of the building
	print("player hit building")

var damage =10
var made_by;

const lifespan=10;
var time_left = lifespan;

var wand_modifiers=[]

func _physics_process(delta):
	time_left = max(0, time_left - delta)
	
	if(time_left<=0):
		queue_free()
	
	for modifier in wand_modifiers:
		if modifier=="decelerate":
			velocity = velocity / (1+delta)
	move_and_slide()


func _on_area_3d_body_entered(body):
	
	if body is CharacterBody3D and body != made_by :
		body.damage(damage)
		queue_free()
	pass # Replace with function body.
