extends Node3D





var wand_modifiers=[] # should be a couple of strings which are called in projectile.gd to modify the projectile. 

const default_reload=0.25; # default rate of fire

var cool_down=0;

var cam
var player_body
var projectile_map
var projectile_scene

const proj_speed = 10.0
# Called when the node enters the scene tree for the first time.
func _ready():
	cam = $"../Camera3D"
	player_body = $".."
	projectile_map = $"../../../projectiles"
	projectile_scene = preload("res://projectile.tscn")

	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	
	# get the plane at the same height as the player
	var dropPlane  = Plane(Vector3(0, 1, 0), -player_body.position.y/2)
	#detect the position the mouse would be at, if projected onto that plane. 
	var position3D = dropPlane.intersects_ray(
							 cam.project_ray_origin(get_viewport().get_mouse_position()),
							 cam.project_ray_normal(get_viewport().get_mouse_position()))
							

	if(position3D): # if the position is valid,
		# set the rotation of the pointer so that it points to the mouse.
		rotation.y = 3.141592 / 2 -Vector2(position3D.x, position3D.z).angle_to_point(Vector2(player_body.position.x,player_body.position.z))
	
	cool_down = max(0,cool_down-delta);
	
	if Input.is_action_pressed("left click") and position3D and cool_down <=0: # if the position is valid, and the left mouse button in pressed,
		
		cool_down = default_reload; ## TODO: make this change with modifiers
		
		var projectile = projectile_scene.instantiate() # instantiate a preloaded scene (initialize it)
		projectile.made_by=$".."
		# calculate the direction the pointer is pointing in
		var direction = (Vector3(position3D.x, player_body.position.y, position3D.z) - player_body.position).normalized()
		# set the velocity of the projectile to the player's vel, plus the direction times speed. 
		# (Ie, make the projectile move relative to the player)
		projectile.velocity = player_body.velocity + direction * proj_speed
		
		# set the position of the particle at the end of the player's pointer.
		projectile.position.x = player_body.position.x + direction.x * 1.15
		projectile.position.y = -player_body.position.y/2 + direction.y * 1.15 # for some reason, player.pos.y is messed up. you have to divide by -2 to get the correct result.
		projectile.position.z = player_body.position.z + direction.z * 1.15
		
		projectile.wand_modifiers = wand_modifiers # apply set modifers to projectile.
		
		# add the projectile to the map the player is currently in
		projectile_map.add_child(projectile)
	
	if Input.is_action_pressed("right click") and position3D and cool_down <=0: # if the position is valid, and the left mouse button in pressed,
		
		cool_down = default_reload * 2; ## TODO: make this change with modifiers
		
		var projectile = projectile_scene.instantiate() # instantiate a preloaded scene (initialize it)
		projectile.made_by=$".."
		# calculate the direction the pointer is pointing in
		var direction = (Vector3(position3D.x, player_body.position.y, position3D.z) - player_body.position).normalized()
		# set the velocity of the projectile to the player's vel, plus the direction times speed. 
		# (Ie, make the projectile move relative to the player)
		projectile.velocity = player_body.velocity + direction * proj_speed
		
		# set the position of the particle at the end of the player's pointer.
		projectile.position.x = player_body.position.x + direction.x * 1.15
		projectile.position.y = -player_body.position.y/2 + direction.y * 1.15 # for some reason, player.pos.y is messed up. you have to divide by -2 to get the correct result.
		projectile.position.z = player_body.position.z + direction.z * 1.15
		
		projectile.wand_modifiers = wand_modifiers # apply set modifers to projectile.
		
		# add the projectile to the map the player is currently in
		projectile_map.add_child(projectile)
		
	pass
