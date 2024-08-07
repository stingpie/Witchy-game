extends CharacterBody3D

var damage =10
var made_by;

var lifespan=10;
var time_left = lifespan;

var initial_speed=0;
var wind_dir=Vector3(1,0,1)

var wand_modifiers=[]

var has_split=false

var projectile_scene

func _ready():
	projectile_scene = preload("res://projectile.tscn")
	wind_dir = velocity.normalized()

func projectile_is_laggin():
	return 1093284094


func _physics_process(delta):
	
	if( $"../".get_child_count()>750):
		queue_free()
	
	time_left = max(0, time_left - delta)
	
	projectile_is_laggin()

	if(time_left<=lifespan/2 and $"../".get_child_count()>250):
		queue_free()
	elif(time_left<=lifespan/4 and $"../".get_child_count()>500):
		queue_free()
	if(time_left<=0):
		queue_free()
	
	for modifier in wand_modifiers:
		if modifier=="decelerate":
			velocity = initial_speed * velocity.normalized() * (2 ** -((lifespan - time_left)))
			
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
				
				projectile.initial_speed = initial_speed
				
				projectile.made_by = made_by if made_by != "player" else "";
				
				add_sibling(projectile) # put the projectile into the world. 
				
				
				# same as above, but in the other direction.
				var projectile2 = self.duplicate()
				
				projectile2.velocity += Vector3(0,-1,0).cross(velocity).normalized();
				projectile2.position += Vector3(0,-1,0).cross(velocity).normalized()*0.1;
				
				projectile2.wand_modifiers = wand_modifiers
				
				projectile2.time_left=lifespan;
				
				
				projectile2.initial_speed = initial_speed
				
				projectile2.made_by = made_by if made_by != "player" else "";
				
				add_sibling(projectile2)
				
				has_split=true
				
				
				queue_free()
			
		if modifier.substr(0,6) == "spiral":
			velocity += Vector3(0,1,0).cross(velocity).normalized()*delta*10;
		
		
			
		if modifier == "cyclone":
			if lifespan - time_left >0:
				velocity += Vector3(0,1,0).cross(velocity).normalized() * initial_speed/10;
		
		if modifier == "wave v":
			velocity +=  sin(float(Time.get_ticks_msec())/200) * Vector3(0,1,0).cross(velocity).normalized() * initial_speed/10;
		
		if modifier == "wave p":
			position +=  sin(float(Time.get_ticks_msec())/200) * Vector3(0,1,0).cross(velocity).normalized() *0.1;
		
		if modifier == "scatter":
			if(abs(sin(float(Time.get_ticks_msec())/1000))<0.1):
				
				wind_dir = (wind_dir *  Vector3(randf()-0.5, 0, randf()-0.5)).normalized()
			velocity =wind_dir*initial_speed;
			
		if modifier == "wind":
			if(abs(sin(float(Time.get_ticks_msec())/1000))<0.01):
				
				wind_dir = (wind_dir *  Vector3(randf()-0.5, 0, randf()-0.5)).normalized()
			position += wind_dir*sin(float(Time.get_ticks_msec())/1000)*initial_speed*delta;
		
		if modifier == "explosion":
			if lifespan - time_left > 1:
				for i in range(10):
					var projectile = self.duplicate() # make a duplicate of this projectile
				
				
					var rand = Vector3(sin(float(i)*6.28/10), 0, cos(float(i)*6.28/10)).normalized()
					
					projectile.velocity = rand * Vector3(0,1,0).cross(velocity).normalized()*initial_speed; # push the projectile to one side. 
					projectile.position += rand * Vector3(0,1,0).cross(velocity).normalized()*0.1; # teleport projectile to one side (proj can currently collide with eachother, so this stops that.)
					
					wand_modifiers.erase("explosion") # prevent this new projectile from splitting.
					
					projectile.wand_modifiers = wand_modifiers # give the new projectile the same modifiers as this one.
					projectile.wand_modifiers.append("lifespan 1")
					
					
					projectile.time_left=lifespan;
					
					projectile.initial_speed = initial_speed
					
					
					add_sibling(projectile) # put the projectile into the world. 
				queue_free()
		
		if modifier.substr(0,8) == "lifespan":
			lifespan = int(modifier.substr(8,-1))
			if(time_left>lifespan):
				time_left = lifespan
				
				
		if modifier == "heal":
			if damage>0:
				damage=-10
			
		if modifier == "accelerate":
			velocity = initial_speed * velocity.normalized() * (2 ** ((lifespan - time_left)))
				
		if modifier.substr(0,5) == "boost":
			initial_speed *= 1.5
			velocity = initial_speed * velocity.normalized()
			wand_modifiers.erase(modifier)
			
		if modifier == "homing":
			var enemies =$"../../Enemies".get_children()
			var enemy=enemies.pick_random()
			for i in range(len(enemies)):
				print(i)
				if((self.global_position - enemy.global_position).length()> (self.global_position - enemies[i].global_position).length()):
					enemy = enemies[i]
					print((self.global_position - enemy.global_position).length(), " ", i)
			if(self.global_position - enemy.global_position).length()>0.001:
				print("			",(self.global_position - enemy.global_position).length())
				var d = delta * 20
				velocity = velocity*(0.9**d) + (1-(0.9**d))*initial_speed * -(self.global_position - enemy.global_position).normalized()
			
	move_and_slide()


func _on_area_3d_body_entered(body):
	
	if body is CharacterBody3D and body.body_name != made_by :
		body.damage(damage)
		queue_free()
	elif body is StaticBody3D:
		queue_free()
	pass # Replace with function body.
