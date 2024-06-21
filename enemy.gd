extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var HP=100;

var state = "stand"

@onready var player = $"../../Player/CharacterBody3D"

func damage(amount):
	HP -= amount

func _physics_process(delta):
	
	#print(state)
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var player_dist = (Vector3(player.position.x, player.position.y, player.position.z) - position).length()
	
	if(HP <= 0):
		state = "dead"
		
	if(state == "dead"):
		scale *= 0.9
		if(scale.length() < 0.1):
			queue_free()
		
	if(state == "stand"):
		velocity *= 0;
		if(player_dist>12):
			state = "approach"
		
	
	if(state == "approach"):
		var direction = (Vector3(player.position.x, player.position.y, player.position.z) - position).normalized()
		
		if(player_dist<4):
			state = "stand"
		
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
