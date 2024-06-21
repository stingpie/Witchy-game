extends CharacterBody3D



const thresh=0.1
const SPEED = 9.25
const JUMP_VELOCITY = 4.5

const max_speed = 15.0

var inventory = {}


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var mass = 30.0
var COF = 3.5

var state ="idle" # potential states : idle, running, slipping, slow running. 

var force = Vector3(0,0,0)
var acceleration = Vector3(0,0,0)
@onready var _animated_sprite = $AnimatedSprite3D

func _on_ready():
	pass

func _physics_process(delta):
		
		
	# calculate normal force and friction force. 
	var normal_force = mass * gravity
	var friction_force = (normal_force * COF)
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Vector2(Input.get_axis("ui_left","ui_right"), Input.get_axis("ui_up", "ui_down")) 
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y))#.normalized()

	
	
	if(direction):
		state = "running"
	else:
		state = "idle"
	
	if direction and (state == "running" or state == "slow running"):
		# apply a force to the character. 
		# Here, the force is proportional to the change in angle between the new and old direction.
		# you can reverse easily, but not turn quickly. I might change this. Depends on how it
		# plays.
		
		#if(velocity.length() < max_speed):
		force.x = mass/15 * direction.x * SPEED if state == "running" else SPEED/2
		force.z = mass/15 * direction.z * SPEED if state == "running" else SPEED/2
			# * (2-thresh)*( 1 + max(0, thresh-velocity.dot(direction)))
			
		#force *=  max(0,min(1,  (max_speed/(abs(velocity.length())+0.001)) - (velocity.normalized() - direction.normalized()).length()    ))
			
		_animated_sprite.play("running")
		
			
	else:
		force.x = 0
		force.z = 0
		
		_animated_sprite.play("idle")
	
	# apply friction
	force.x = force.x - sign(velocity.x) * friction_force * delta
	force.z = force.z - sign(velocity.z) * friction_force * delta
	
	# set acceleration due to the force
	acceleration.x = force.x / mass
	acceleration.z = force.z / mass
	
	if(velocity.length()<0.25):
		velocity *= 0.9;
		acceleration *= 0.9;
		force *= 0.9;
	
	
	if(is_on_floor()):
		# apply acceleration if the player is on the floor (ie, not jumping) 
		velocity.x += acceleration.x
		velocity.z += acceleration.z
	
	move_and_slide()
