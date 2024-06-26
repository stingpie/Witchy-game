extends Node2D


@onready var left_char = $"Node2D2"
@onready var right_char = $"Node2D3"
@onready var text_box = $"Node2D"
var curve

var time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	curve = load("res://dialog/bounce.tres")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	begin(delta)
	pass


const speed=2
const char_distance = 350
const text_distance = 250
func begin(delta):
	time+=delta*speed
	
	if(time<1):
		text_box.get_child(0).position.y = -curve.sample(time)*text_distance
	elif(time<2):
		left_char.get_child(0).position.x = curve.sample(time-1)*char_distance
	elif(time<3):
		right_char.get_child(0).position.x = -curve.sample(time-2)*char_distance
	
	
