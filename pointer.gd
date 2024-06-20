extends Node3D


var cam
var player_body
# Called when the node enters the scene tree for the first time.
func _ready():
	cam = $"../Camera3D"
	player_body = $".."
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var dropPlane  = Plane(Vector3(0, 1, 0), -player_body.position.y/2)
	var position3D = dropPlane.intersects_ray(
							 cam.project_ray_origin(get_viewport().get_mouse_position()),
							 cam.project_ray_normal(get_viewport().get_mouse_position()))
	if(position3D):
		rotation.y = 3.141592 / 2 -Vector2(position3D.x, position3D.z).angle_to_point(Vector2(player_body.position.x,player_body.position.z))
	
	
	pass
