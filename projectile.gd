extends CharacterBody3D

var damage =10
var made_by;

const lifespan=10;
var time_left = lifespan;

var wand_modifiers=[]

var has_split=false

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
			
		if modifier.substr(0,5) == "split" and not has_split: # split the particle in two after a set period of time.
			if lifespan - time_left > 0.35:
				var projectile = self.duplicate() # make a duplicate of this projectile
				
				
				# these lines use the cross product to figure out a perpendicular vector. 
				# the cross product of two 3d vectors will return a vector perpendicular to both.
				# e.g. Vector3(1,0,0).cross(Vector3(0,1,0) = Vector3(0,0,1)
				projectile.velocity += Vector3(0,1,0).cross(velocity).normalized(); # push the projectile to one side. 
				projectile.position += Vector3(0,1,0).cross(velocity).normalized()*0.1; # teleport projectile to one side (proj can currently collide with eachother, so this stops that.)
				
				wand_modifiers.erase("split") # prevent this new projectile from splitting.
				
				projectile.wand_modifiers = wand_modifiers # give the new projectile the same modifiers as this one.
				
				projectile.time_left=lifespan;
				
				add_sibling(projectile) # put the projectile into the world. 
				
				
				# same as above, but in the other direction.
				var projectile2 = self.duplicate()
				
				projectile2.velocity += Vector3(0,-1,0).cross(velocity).normalized();
				projectile2.position += Vector3(0,-1,0).cross(velocity).normalized()*0.1;
				
				projectile2.wand_modifiers = wand_modifiers
				
				projectile2.time_left=lifespan;
				
				add_sibling(projectile2)
				
				has_split=true
				
				queue_free()
			
		if modifier.substr(0,6) == "spiral":
			velocity += Vector3(0,1,0).cross(velocity).normalized()*delta*10;
		if modifier.substr(0,7) == "cyclone":
			if lifespan - time_left >0.35:
				velocity += Vector3(0,1,0).cross(velocity).normalized();
		
			
	move_and_slide()


func _on_area_3d_body_entered(body):
	
	if body is CharacterBody3D and body != made_by :
		body.damage(damage)
		#queue_free()
	pass # Replace with function body.
