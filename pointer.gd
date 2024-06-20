extends Node3D


var cam
var player_body
var projectile_map
var projectile_scene

const proj_speed = 10.0
# Called when the node enters the scene tree for the first time.
func _ready():
	cam = $"../Camera3D"
	player_body = $".."
	projectile_map = $"../../../projectiles"
	projectile_scene = preload("res://projectile.tscn")

	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var dropPlane  = Plane(Vector3(0, 1, 0), -player_body.position.y/2)
	var position3D = dropPlane.intersects_ray(
							 cam.project_ray_origin(get_viewport().get_mouse_position()),
							 cam.project_ray_normal(get_viewport().get_mouse_position()))
	if(position3D):
		rotation.y = 3.141592 / 2 -Vector2(position3D.x, position3D.z).angle_to_point(Vector2(player_body.position.x,player_body.position.z))
	
	if Input.is_action_pressed("left click") and position3D:
		var projectile = projectile_scene.instantiate()
		var direction = (Vector3(position3D.x, player_body.position.y, position3D.z) - player_body.position).normalized()
		projectile.velocity = player_body.velocity + direction * proj_speed
		projectile.position.x = player_body.position.x + direction.x * 1.15
		projectile.position.y = -player_body.position.y/2 + direction.y * 1.15 
		projectile.position.z = player_body.position.z + direction.z * 1.15
		projectile_map.add_child(projectile)
	pass
