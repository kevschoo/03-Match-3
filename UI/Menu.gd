extends Control
onready var global = get_node("/root/Global")
func _ready():
	pass


func _on_Play_pressed():
	var _target = get_tree().change_scene("res://Game.tscn")
	global.score = 0
	global.blue = 0
	global.red = 0
	global.green = 0
	global.white = 0
	


func _on_Quit_pressed():
	get_tree().quit()
