extends Node3D


var cam
# Called when the node enters the scene tree for the first time.
func _ready():
	cam = $"../Camera3D"
	print(cam)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var dropPlane  = Plane(Vector3(0, 1, 0), 0)
	var position3D = dropPlane.intersects_ray(
							 cam.project_ray_origin(get_viewport().get_mouse_position()),
							 cam.project_ray_normal(get_viewport().get_mouse_position()))
	rotation.y = 3.141592 / 2 -Vector2(position3D.x, position3D.z).angle_to_point(Vector2($"..".position.x,$"..".position.z))
	
	
	pass
