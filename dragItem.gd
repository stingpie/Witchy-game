extends Node3D

var item=""
var is_dragged=false;
var cam

func set_item(text, sprite):
	
	$Sprite3D.set_texture(sprite)
	item = text
	
func _ready():
	
	cam = $"../../../../Camera3D"
	print(position)
func _process(delta):
	
	# get the plane at the same height as the player
	var dropPlane  = Plane(Vector3(0, 0, 1), 0)
	#detect the position the mouse would be at, if projected onto that plane. 
	
	var position3D = dropPlane.intersects_ray(
							 cam.project_ray_origin(get_viewport().get_mouse_position()),
							 cam.project_ray_normal(get_viewport().get_mouse_position()))
							
	
	if(is_dragged):
		position = position3D - $"../".global_position #- $"../..".position - $"../../..".position #- $"../../../..".position
		if( not Input.is_action_pressed("left click")):
			is_dragged = false


func _on_area_3d_input_event(camera, event, position, normal, shape_idx):
	if event.is_action_pressed("left click"):
		is_dragged=true
	if event.is_action_released("left click"):
		is_dragged=false
	#	position.y+=1
	pass # Replace with function body.
