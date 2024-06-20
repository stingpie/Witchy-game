extends CharacterBody3D



const thresh=0.5
const SPEED = 4.00
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var mass = 8.0
var COF = 3.0


var force = Vector3(0,0,0)
var acceleration = Vector3(0,0,0)

func _physics_process(delta):
		
	
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
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		force.x = direction.x * SPEED * (2-thresh)*(1 + max(0, thresh-velocity.dot(direction)))
		force.z = direction.z * SPEED * (2-thresh)*(1 + max(0, thresh-velocity.dot(direction)))
	else:
		force.x = 0#move_toward(velocity.x, 0, SPEED)
		force.z = 0#move_toward(velocity.z, 0, SPEED)
		
	
	force.x = force.x - sign(velocity.x) * friction_force * delta
	force.z = force.z - sign(velocity.z) * friction_force * delta
	
	acceleration.x = force.x / mass
	acceleration.z = force.z / mass
	
	if(is_on_floor()):
		velocity.x += acceleration.x
		velocity.z += acceleration.z
	
	#if(acceleration.length() < 0.25):
	#	acceleration /= 10 * delta
	
	#if( velocity.length() <0.25 ):
	#	velocity /= 10 * delta
	
	
	
	move_and_slide()
