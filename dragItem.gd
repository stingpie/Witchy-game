extends Node3D

var item=""
var is_dragged=false;
var cam
var textures=[]

func _init():
	for texture in DirAccess.open("res://graphics/GUI/fluids/").get_files():
		if not "import" in texture:
			textures.append(load("res://graphics/GUI/fluids/"+texture))

func set_item(text):#, sprite):
	

	
	$Node3D/Sprite3D3.texture = load("res://graphics/GUI/Potion_Bottle_HOLE_MASK.png")
	
	$Node3D/Sprite3D3.material_overlay.set_shader_parameter("texture_albedo", textures[text[int(len(text)/2)].to_ascii_buffer()[0]%len(textures)])
	var main_color =  Vector3(float(text.to_ascii_buffer()[0]%16)/16, float(text.to_ascii_buffer()[1]%16)/16, float(text.to_ascii_buffer()[2]%16)/16)/2 + Vector3(0.5,0.5,0.5)
	var aux_color = Vector3(float(text.to_ascii_buffer()[-3]%16)/16, float(text.to_ascii_buffer()[-2]%16)/16, float(text.to_ascii_buffer()[-1]%16)/16)/2
	
	if(main_color.length()<1):
		#print("aa")
		main_color *= main_color.length()
		#main_color -= main_color
	
	if (main_color - aux_color).length()<0.5:
		main_color *= 1.0/(main_color - aux_color).length()
		aux_color = Vector3(0,0,0)
	
	
	$Node3D/Sprite3D3.material_overlay.set_shader_parameter("main_color", main_color)
	$Node3D/Sprite3D3.material_overlay.set_shader_parameter("aux_color", aux_color)
	
	item = text
	
func _ready():
	
	cam = $"../../../../Camera3D"
	
func _process(delta):
	# get the plane at the same height as the player
	var dropPlane  = Plane(Vector3(0, 0, 1), global_position.z)
	#detect the position the mouse would be at, if projected onto that plane. d
	
	var position3D = dropPlane.intersects_ray(
							 cam.project_ray_origin(get_viewport().get_mouse_position()),
							 cam.project_ray_normal(get_viewport().get_mouse_position()))
							
	
	if(is_dragged and position3D):
		#print(position3D, " ", $"../".global_position )
		
		position = position3D - $"../".global_position #- $"../..".position - $"../../..".position #- $"../../../..".position
		#print(position)
		if( not Input.is_action_pressed("left click")):
			$Sprite3D.no_depth_test=false
			$"Sprite3D".position.z=0
			position.z=0
			$Area3D/CollisionShape3D.shape.size.z=0.1
			is_dragged = false


func _on_area_3d_input_event(camera, event, position, normal, shape_idx):
	if event.is_action_pressed("left click"):
		
		$"Sprite3D".position.z=0
		$Sprite3D.no_depth_test=true
		is_dragged=true
	if event.is_action_released("left click"):
		is_dragged=false
		position.z=0
		$Area3D/CollisionShape3D.shape.size.z=0.1
		$"Sprite3D".position.z=0
		$Sprite3D.no_depth_test=false
	#	position.y+=1
	pass # Replace with function body.
