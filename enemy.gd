extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var HP=100;



const animations=["east", "north east", "north", "north west", "west", "south west", "south", "south east"]


var state = "stand"

@onready var player = $"../../Player/PlayerBody3D"



func damage(amount):
	HP -= amount

func _physics_process(delta):
	# this controls the enemy. I should definitely improve the ai, give a couple
	# of different behaviors. 
	
	
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var player_dist = (Vector3(player.position.x, player.position.y, player.position.z) - position).length()
	
	var direction = (Vector3(player.position.x, player.position.y, player.position.z) - position).normalized()
	
	$"Node3D".fire_proj()
	
	
	if(HP <= 0):
		state = "dead"
		
	if(state == "dead"):
		scale *= 0.9 # TODO: make this based on delta
		if(scale.length() < 0.1):
			queue_free()
		
	if(state == "stand"):
		velocity *= 0;
		if(player_dist>12):
			state = "approach"
		
	
	if(state == "approach"):
		
		
		# this code really sucks.
		# this first line figures out the angle between the enemy and the player. 
		# the second line takes the angle and forces it to range between 0 & 7 (inclusive.)
		# this new value is then used to index into the animations array, which picks the animation to play.
		var rot = Vector2(-position.x - get_parent().position.x,position.z + get_parent().position.z).angle_to_point(Vector2(-player.position.x,player.position.z))
		var index = int(round((rot+PI)/(2*PI)*8))%8
		$"AnimatedSprite3D".play(animations[index])
		
		
		
		
		if(player_dist<4):
			state = "stand"
		
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
