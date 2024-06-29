extends Node3D

var item=""

func set_item(text, sprite):
	print(sprite)
	$Sprite3D.set_texture(sprite)
	item = text
