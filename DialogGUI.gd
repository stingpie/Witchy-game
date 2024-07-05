extends Node2D


@onready var left_char = $"Node2D2"
@onready var right_char = $"Node2D3"
@onready var text_box = $"Node2D"
var curve

var time = 0
var dialog=[]
var dialog_index=0;
var is_open =false;
var is_opening=false;
var is_closing=false;


func is_closed():
	return not (is_open or is_opening or is_closing);


# Called when the node enters the scene tree for the first time.
func _ready():
	curve = load("res://dialog/bounce.tres")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(is_opening):
		begin(delta)
	if(is_open):
		show_dialog()
	if(is_closing):
		close(delta)
	
	
	
	pass


const dim = 0.5

func show_dialog():
	if(dialog_index >= len(dialog)):
		is_closing=true
		time = 0
		dialog_index=0
	else:
		var line = dialog[dialog_index]
		if(line[0]=="B"):
			$"Node2D2/Left Character".modulate = Color(dim,dim,dim,1)
			$"Node2D3/Right Character".modulate = Color(1,1,1,1)
		else:
			$"Node2D3/Right Character".modulate = Color(dim,dim,dim,1)
			$"Node2D2/Left Character".modulate = Color(1,1,1,1)
			
		$Node2D/Node2D/Label.text = line.substr(2,-1)
		if Input.is_action_just_pressed("interact") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			dialog_index += 1

const speed=2
const char_distance = 350
const text_distance = 350
func begin(delta):
	
	if(not is_open):
		is_opening=true
		time+=delta*speed
		
		if(time<1):
			text_box.get_child(0).position.y = -curve.sample(time)*text_distance
		elif(time<2):
			left_char.get_child(0).position.x = curve.sample(time-1)*char_distance
		elif(time<3):
			right_char.get_child(0).position.x = -curve.sample(time-2)*char_distance
		else:
			is_opening=false
			is_open=true
	

func close(delta):
	is_closing=true
	is_open=false
	
	time+=delta*speed
	if(time<1):
		text_box.get_child(0).position.y = -text_distance + curve.sample(time)*text_distance
		left_char.get_child(0).position.x = char_distance - curve.sample(time)*char_distance
		right_char.get_child(0).position.x = -char_distance + curve.sample(time)*char_distance
	else:
		text_box.get_child(0).position.y = 0
		left_char.get_child(0).position.x = 0
		right_char.get_child(0).position.x = 0

		is_closing=false
		$"../../".unpause()
		time=0
