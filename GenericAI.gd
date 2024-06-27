extends Node


## AI movement types:
## 1) keep close, but hold your ground. 
##		move towards player if there is a big enough difference, but stand still any closer. 
## 2) hover
##		move close to the player, but try to stay a certain distance away. 
## 3) circle
##		move in a spiral, closer and closer to the player. 
## 4) ambush
## 		stay still until player comes within a certain distance. Then, move around quickly.

var mode = "circle"
var state ="stand"

var close=5
var far = 20
const curl=10


func get_control(Player, Enemy):
	
	var player_dist = (Player.position - Enemy.position - Enemy.get_parent().position).length()
	
	var direction = (Player.position - Enemy.position - Enemy.get_parent().position).normalized()
	
	
	if(mode == "close"):
			
		if(state == "stand"):
			
			if(player_dist>far):
				state = "approach"
			return {'x':0, 'y':0, 'state':state}
		
		if(state == "approach"):
			
			if(player_dist<close):
				state = "stand"
				return {'x':0, 'y':0, 'state':state}
				
			if direction:
				return {'x':direction.x, 'y':direction.z, 'state':state}
			else:
				return {'x':0, 'y':0, 'state':state}
				
	elif(mode == "hover"):
		if(player_dist>far):
			state="approach"
			if direction:
				return {'x':direction.x, 'y':direction.z, 'state':state}
			else:
				return {'x':0, 'y':0, 'state':state}
				
		elif(player_dist<close):
			state="approach"
			if direction:
				return {'x':-direction.x, 'y':-direction.z, 'state':state}
			else:
				return {'x':0, 'y':0, 'state':state}
		else:
			state="stand"
			return {'x':0, 'y':0, 'state':state}
			
	elif(mode == "circle"):
		if(player_dist>close):
			state="approach"
			if direction:
				direction += direction.cross(Vector3(0,1,0))*curl
				direction = direction.normalized()
				return {'x':direction.x, 'y':direction.z, 'state':state}
			else:
				return {'x':0, 'y':0, 'state':state}
		else:
			state = "stand"
			return {'x':0, 'y':0, 'state':state}
			
	elif(mode == "ambush"):
		if(player_dist<close or state == "approach"):
			state="approach"
			if(player_dist>close+0.5):
				if direction:
					return {'x':direction.x, 'y':direction.z, 'state':state}
				else:
					return {'x':0, 'y':0, 'state':state}
					
			elif(player_dist<close-0.5):
				if direction:
					return {'x':-direction.x, 'y':-direction.z, 'state':state}
				else:
					return {'x':0, 'y':0, 'state':state}
			else:
				return {'x':0, 'y':0, 'state':state}
		else:
			
			return {'x':0, 'y':0, 'state':state}
	
	
	return {'x':0, 'y':0, 'state':'ERROR'}
