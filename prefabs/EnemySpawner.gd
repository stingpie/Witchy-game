extends Node3D

@export var area : CylinderShape3D;
@export var enemy : Node3D;

@export var number = 1;


func _ready():
	for i in range(number):
		var enemy_to_place = enemy.duplicate();
		var x = randf()*area.radius*2 - area.radius;
		var y = randf()*area.radius*2 - area.radius;
		var z = randf()*area.height - area.height/2;
