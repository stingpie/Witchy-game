extends Node3D

@export var herb_type = ""
@export_file var sprite

func _ready():
	$HerbArea3D/Sprite3D.texture = load(sprite)
	$HerbArea3D.herb_type = herb_type
