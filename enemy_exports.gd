extends Node3D

@export var spells=["split"]
@export var proj_speed=5.0
@export_dir var sprite_dir = "res://graphics/enemy/snake/"

@export var close=4.0;
@export var far = 20.0;
@export var ai ="circle"


const directions8 = ["North", "North-East", "East", "South-East", "South", "South-West", "West", "North-West"]


func _ready():
	$"EnemyBody3D/Node3D".wand_modifiers = spells
	$"EnemyBody3D/Node3D".proj_speed = proj_speed
	var dir = DirAccess.open(sprite_dir)
	for directory in dir.get_directories():
		$"EnemyBody3D/AnimatedSprite3D".sprite_frames.add_animation(directory)
		for frame in DirAccess.open(sprite_dir+"/"+directory).get_files():
			if not "import" in frame:
				
				$"EnemyBody3D/AnimatedSprite3D".sprite_frames.add_frame(directory,load(sprite_dir+"/"+directory+"/"+frame) )
	$"EnemyBody3D".AI.close = close;
	$"EnemyBody3D".AI.far = far;
	$"EnemyBody3D".AI.mode = ai;
	
