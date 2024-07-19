extends CharacterBody3D



const thresh=0.1
const SPEED = 9.25
const JUMP_VELOCITY = 4.5

const max_speed = 15.0

var inventory = {"eye of newt":1, 
			"fenny snake":1, 
			"toe of frog":1, 
			"wool of bat":1, 
			"tongue of dog":1, 
			"fork of adder":1, 
			"sting of worm":1, 
			"leg of lizard":1, 
			"wing of howlet":1,
			"blood of baboon":1}
var HP = 100;

const TimeEvent = preload("res://TimeEvent.gd")

var brew_scene = preload("res://brewCauldron.tscn")
const accel = preload("res://pseudoAcceleration.tres")

var time_effects=[]

var input_duration=0

var tags=[]

var paused = false

var body_name="player"

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var mass = 30.0
var COF = 3.5

var state ="idle" # potential states : idle, running, slipping, slow running. 
var in_inventory=false


var force = Vector3(0,0,0)
var acceleration = Vector3(0,0,0)
@onready var _animated_sprite = $AnimatedSprite3D

func _ready():
	brew_scene = brew_scene.instantiate()
	add_child(brew_scene)
	brew_scene.visible = false;
	brew_scene.set_process(false);
	pass

func _physics_process(delta):
	
	$"Camera3D/CombatGui/ProgressBar".value = HP;
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

	if(input_dir.length()>0):
		input_duration += delta
	else:
		input_duration = 0
	
	if(direction):
		state = "running"
	else:
		state = "idle"
		
	if Input.is_action_just_pressed("open inventory"):
		# toggle inventory screen
		if not in_inventory:
			brew_scene.visible = true;
			brew_scene.propagate_call("set_process", [true])
			brew_scene.propagate_call("set_physics_process", [true])
			for node in $"../..".get_children():
				
				if(node.name != $"../".name):
					node.propagate_call("set_process", [false])
					node.propagate_call("set_physics_process", [false])
					node.visible = false;
			$Node3D.visible=false
			$Node3D.set_process(false)
			brew_scene.get_node("Camera3D").make_current()
			$AnimatedSprite3D.visible=false
			$Camera3D/CombatGui.visible=false
			
			in_inventory = true
			
			brew_scene.get_node("Bookshelf left").update_items(inventory)
			
			brew_scene.get_node("Bookshelf right").update_wands($Camera3D/CombatGui/Node2D.spells)
			
			for effect in time_effects:
				effect.pause()
			
		else:
			brew_scene.visible = false;
			brew_scene.propagate_call("set_process", [false])
			brew_scene.propagate_call("set_physics_process", [false])
			for node in $"../..".get_children():
				if(node.name != $"../".name):
					node.propagate_call("set_process", [true])
					node.propagate_call("set_physics_process", [true])
					node.visible = true;
			$Node3D.visible=true
			$Node3D.set_process(true)
			$Camera3D.make_current()
			$AnimatedSprite3D.visible=true
			$Camera3D/CombatGui.visible=true
			
			for i in range(4):
				$"Camera3D/CombatGui/Node2D".spells[i]=[]
				for brew in brew_scene.get_node("Bookshelf right/Label3D"+str(i+1)+"/Area3D").get_overlapping_areas():
					$"Camera3D/CombatGui/Node2D".spells[i].append(brew.get_parent().item)
			
			brew_scene.get_node("Bookshelf right").clear()
			brew_scene.get_node("Bookshelf left").clear()
			
			in_inventory = false
			
			for effect in time_effects:
				effect.unpause()
			
	if direction and (state == "running" or state == "slow running") and not in_inventory:
		# apply a force to the character. 
		# Here, the force is proportional to the change in angle between the new and old direction.
		# you can reverse easily, but not turn quickly. I might change this. Depends on how it
		# plays.
		
		#if(velocity.length() < max_speed):
		#force.x = mass/15 * direction.x * SPEED if state == "running" else SPEED/2
		#force.z = mass/15 * direction.z * SPEED if state == "running" else SPEED/2
		
		
		# this is the most basic movement system. The velocity is just set as the direction you're traveling. 
		# this is the most responsive movement, but it is a very brutish way of doing things.
		velocity.x = direction.x * SPEED * (accel.sample(input_duration) if input_duration<1 and is_on_floor() else 1)
		velocity.z = direction.z * SPEED * (accel.sample(input_duration) if input_duration<1 and is_on_floor() else 1)
		
		
			# * (2-thresh)*( 1 + max(0, thresh-velocity.dot(direction)))
			
		#force *=  max(0,min(1,  (max_speed/(abs(velocity.length())+0.001)) - (velocity.normalized() - direction.normalized()).length()    ))
			
		_animated_sprite.play("running")
		
			
	else: # if nothing is pressed
		
		velocity.x=0
		velocity.z=0
		#force.x = 0
		#force.z = 0
		
		_animated_sprite.play("idle")
	#
	## apply friction
	#force.x = force.x - sign(velocity.x) * friction_force * delta
	#force.z = force.z - sign(velocity.z) * friction_force * delta
	#
	## set acceleration due to the force
	#acceleration.x = force.x / mass
	#acceleration.z = force.z / mass
	#
	#if(velocity.length()<0.25):
		#velocity *= 0.9;
		#acceleration *= 0.9;
		#force *= 0.9;
	#
	#
	#if(is_on_floor()):
		## apply acceleration if the player is on the floor (ie, not jumping) 
		#velocity.x += acceleration.x
		#velocity.z += acceleration.z
	#
	
	
	for event in time_effects:
		var effect = event.kill_if_over()
		if(effect):
			if(effect[0] == "HP"):
				HP += effect[1]
			if(effect[0] == "item"):
				inventory.append(effect[1])
			if(effect[0] == "Potion"):
				var wands = $Cameara3D/CombatGui/Node2D.spells
				var order = [0,1,2,3]
				order.shuffle()
				for i in range(4):
					if(len(wands[order[i]])<4):
						wands[order[i]].append(effect[1])
						break
				
			time_effects.erase(event)
	
	if(Input.is_action_just_pressed("time spell")):
		damage(-10)
		var event = TimeEvent.new()
		event.type = "HP"
		event.variable=-10
		event.duration = 10
		time_effects.append(event)
	
	if(not paused):
		move_and_slide()

func damage(amount): # apply damage to player.
	HP -= amount
	#$"Camera3D/CombatGui/ProgressBar".value = HP;
	if(HP<=0):# GAME OVER
		get_tree().change_scene_to_file("res://game over.tscn")
		

func pause():
	for node in $"../..".get_children():
		if(node.name != $"../".name):
			node.propagate_call("set_process", [false])
			node.propagate_call("set_physics_process", [false])
	for effect in time_effects:
		effect.pause()
	paused = true
	
func unpause():
	for node in $"../..".get_children():
		if(node.name != $"../".name):
			node.propagate_call("set_process", [true])
			node.propagate_call("set_physics_process", [true])
	for effect in time_effects:
		effect.unpause()
	paused = false


