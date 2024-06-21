extends CharacterBody3D

func _hit_building(area): #area is the Area2D of the building
	print("player hit building")

var damage =10
var made_by;

const lifespan=10;
var time_left = lifespan;

var wand_modifiers=[]

var projectile_scene

func _ready():
	projectile_scene = preload("res://projectile.tscn")


func _physics_process(delta):
	time_left = max(0, time_left - delta)
	
	if(time_left<=0):
		queue_free()
	
	for modifier in wand_modifiers:
		if modifier=="decelerate":
			velocity = velocity / (1+delta)
			
		if modifier.substr(0,5) == "split": # split the particle in two after a set period of time.
			if lifespan - time_left > 0.35:
				var projectile = self.duplicate()
				projectile.velocity += Vector3(0,1,0).cross(velocity).normalized();
				projectile.position += Vector3(0,1,0).cross(velocity).normalized()*0.1;
				
				add_sibling(projectile)
				
				var projectile2 = self.duplicate()
				
				projectile2.velocity += Vector3(0,-1,0).cross(velocity).normalized();
				projectile2.position += Vector3(0,-1,0).cross(velocity).normalized()*0.1;
				
				add_sibling(projectile2)
				
				queue_free()
			
	move_and_slide()


func _on_area_3d_body_entered(body):
	
	if body is CharacterBody3D and body != made_by :
		body.damage(damage)
		queue_free()
	pass # Replace with function body.
