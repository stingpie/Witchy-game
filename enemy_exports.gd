extends Node3D

@export var spells=["split"]
@export var proj_speed=5.0
@export_dir var sprite_dir = "res://graphics/enemy/snake/"
@export var enemy_name = "snake"


@export var close=4.0;
@export var far = 20.0;
@export var activate_range = 0.0;
@export var initial_path_range=10.0;
@export var ai ="circle"
@export var speed=5; 


#const directions8 = ["North", "North-East", "East", "South-East", "South", "South-West", "West", "North-West"]


func _ready():
	$"EnemyBody3D/Node3D".wand_modifiers = spells
	$"EnemyBody3D/Node3D".proj_speed = proj_speed
	var dir = DirAccess.open(sprite_dir)
	$"EnemyBody3D/AnimatedSprite3D".sprite_frames = SpriteFrames.new()
	var directories = dir.get_directories()
	for directory in directories:
		$"EnemyBody3D/AnimatedSprite3D".sprite_frames.add_animation(directory)
		#$EnemyBody3D.animations.append(directory)
		
		$EnemyBody3D.num_animations=len(directories) - (1 if "idle" in directories else 0)
		for frame in DirAccess.open(sprite_dir+"/"+directory).get_files():
			if not "import" in frame:
				
				$"EnemyBody3D/AnimatedSprite3D".sprite_frames.add_frame(directory,load(sprite_dir+"/"+directory+"/"+frame) )
	
	$"EnemyBody3D".AI.close = close;
	$"EnemyBody3D".AI.far = far;
	$"EnemyBody3D".AI.mode = ai;
	$"EnemyBody3D".AI.move_range = initial_path_range;
	$"EnemyBody3D".activate_range=activate_range;
	$EnemyBody3D/Node3D.enemy_name = enemy_name
	$EnemyBody3D.body_name = enemy_name
	$EnemyBody3D.SPEED = speed
