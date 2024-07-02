extends Node3D





#var wand_modifiers=["explosion"] # should be a couple of strings which are called in projectile.gd to modify the projectile. 

const default_reload=0.25; # default rate of fire

var cool_down=0;

var cam
var body
var projectile_map
var projectile_scene
var parent

var wand_modifiers=[];



var proj_speed = 5.0
# Called when the node enters the scene tree for the first time.
func _ready():
	body = $".."
	parent = $"../.."
	projectile_map = $"../../../projectiles"
	projectile_scene = preload("res://projectile.tscn")

	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	cool_down = max(0,cool_down-delta);
	pass
	
func fire_proj():
	var position3D = $"../../../Player/PlayerBody3D".position
	if  position3D and cool_down <=0: # if the position is valid, and the left mouse button in pressed,
		
		cool_down = default_reload; ## TODO: make this change with modifiers
		
		var projectile = projectile_scene.instantiate() # instantiate a preloaded scene (initialize it)
		projectile.made_by=$".."
		# calculate the direction the pointer is pointing in
		var direction = (Vector3(position3D.x, body.position.y, position3D.z) - body.position - parent.position).normalized()
		direction.y=0
		# set the velocity of the projectile to the player's vel, plus the direction times speed. 
		# (Ie, make the projectile move relative to the player)
		projectile.velocity = (Vector3(0,0,0) if "abs vel" in wand_modifiers else body.velocity) + direction * proj_speed
		projectile.scale*=1
		
		# set the position of the particle at the end of the player's pointer.
		projectile.position.x = body.position.x + parent.position.x + direction.x * 1.15
		projectile.position.y = -body.position.y/2 + parent.position.y + direction.y * 1.15 # for some reason, player.pos.y is messed up. you have to divide by -2 to get the correct result.
		projectile.position.z = body.position.z + parent.position.z + direction.z * 1.15
		
		
		
		projectile.wand_modifiers = wand_modifiers.duplicate() # apply set modifers to projectile.
		
		projectile.get_node("Projectile/AnimatedSprite3D").play("evil")
		
		projectile.initial_speed = proj_speed
		# add the projectile to the map the player is currently in
		projectile_map.add_child(projectile)

	pass
