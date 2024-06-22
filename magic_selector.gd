extends Node2D


var spells = [["split"],["decelerate"],["decelerate","split"],[]]

var spell_index=0;
const max_spells=4;


func pick_spell():
	return spells[spell_index];
	


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if Input.is_action_just_pressed("middle wheel") or Input.is_action_just_pressed("tab"):
		get_child(0).get_child(spell_index).get_child(0).color = Color(0,0,0)
		
		spell_index = (spell_index + (3 if (Input.is_action_pressed("shift")) else 1 ) ) % max_spells
		get_child(0).get_child(spell_index).get_child(0).color = Color(1,1,1)
		
	pass
