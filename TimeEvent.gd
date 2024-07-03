extends Node

class_name TimeEvent

var time_of_creation=0; # in milliseconds
var duration=0.0; # in seconds
var type=""
var variable: Variant

var time_of_pause=0;


func pause():
	time_of_pause=Time.get_ticks_msec()

func unpause():
	duration+= (Time.get_ticks_msec() - time_of_pause) / 1000
	time_of_pause=0

func _init():
	time_of_creation = Time.get_ticks_msec()
	
func is_over():
	return time_of_pause == 0 and Time.get_ticks_msec() - time_of_creation > duration * 1000;

func get_val():
	if(is_over()):
		return [type, variable]
	else:
		return null

func kill_if_over():
	if(is_over()):
		queue_free()
		return [type, variable]
	else:
		return null
