extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var HP=100;
var activate_range=0;


const animations=["East", "North-East", "North", "North-West", "West", "South-West", "South", "South-East"]
var num_animations=1

var state = "deactivated"

@onready var player = $"../../../Player/PlayerBody3D"


var AI = preload("res://GenericAI.gd")

func _ready():
	AI= AI.new()


func damage(amount):
	HP -= amount

func _physics_process(delta):
	# this controls the enemy. I should definitely improve the ai, give a couple
	# of different behaviors. 
	
	var player_dist = (Vector3(player.global_position.x, player.global_position.y, player.global_position.z) - global_position).length()
	if(state=="deactivated"):
		if(player_dist<activate_range):
			state="standing"
		return
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	
	#var direction = (Vector3(player.position.x, player.position.y, player.position.z) - position).normalized()
	var direction = null
	
	$"Node3D".fire_proj()
	
	
	
	if(HP <= 0):
		state = "dead"
		
	if(state == "dead"):
		scale *= 0.9 # TODO: make this based on delta
		if(scale.length() < 0.1):
			queue_free()
	else:
		var command = AI.get_control(player, self)
		
		#print(command)
		
		state = command['state']
		direction = Vector2(command['x'], command['y'])
		
	if(state == "stand"):
		if($AnimatedSprite3D.sprite_frames.has_animation("idle")):
			$AnimatedSprite3D.play("idle")
		

		
	

	
	# this code really sucks.
	# this first line figures out the angle between the enemy and the player. 
	# the second line takes the angle and forces it to range between 0 & 7 (inclusive.)
	# this new value is then used to index into the animations array, which picks the animation to play.
	var rot = Vector2(-position.x - get_parent().position.x,position.z + get_parent().position.z).angle_to_point(Vector2(-player.position.x,player.position.z))
	var index = (int(round((rot+PI)/(2*PI)*num_animations))%num_animations)* 8/num_animations
	$"AnimatedSprite3D".play(animations[index])
	
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.y * SPEED
	else:
		velocity = Vector3(0,0,0)
		#if direction:
		#	velocity.x = direction.x * SPEED
		#	velocity.z = direction.z * SPEED
		#else:
		#	velocity.x = move_toward(velocity.x, 0, SPEED)
	#		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
