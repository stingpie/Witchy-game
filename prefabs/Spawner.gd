extends Node3D

@export var area : CylinderShape3D;
@export var nodes : Array[PackedScene];

@export var number = 1;


func _ready():
	
	
	for i in range(number):
		print(i)
		var node = nodes.pick_random().instantiate();
		var x = randf()*area.radius*2 - area.radius;
		var y = randf()*area.radius*2 - area.radius;
		while( x*x + y*y > area.radius*area.radius):
			x = randf()*area.radius*2 - area.radius;
			y = randf()*area.radius*2 - area.radius;
		var z = randf()*area.height - area.height/2;
		
		node.position = Vector3(x,z,y)
		print(node.global_position)
		get_tree().root.get_child(0).get_node("Enemies").add_child(node)
		print(get_tree().root.get_child(0).get_node("Enemies").get_children())
		
	
	
