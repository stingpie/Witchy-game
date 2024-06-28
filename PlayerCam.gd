extends Camera3D



func _process(delta):
	if Input.is_action_just_released("scroll up"):
		position.y -= delta * position.y * 5
		
		rotation.x = 3*PI/2 + Vector2(position.y,position.z).angle()
		
	if Input.is_action_just_released("scroll down"):
		position.y += delta* position.y * 5
		
		rotation.x = 3*PI/2 + Vector2(position.y,position.z).angle()
