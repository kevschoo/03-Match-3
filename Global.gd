extends Node

var onGame2 = false
var blue = 0
var green = 0
var red = 0
var white = 0
var score = 0
signal changed
var scores = {
	0:0,
	1:0,
	2:0,
	3:10,
	4:20,
	5:50,
	6:100,
	7:200,
	8:300,
	9:1000
}

func _unhandled_input(event):
	if event.is_action_pressed("quit"):
		get_tree().quit()

func change_score(s):
	score += s
	emit_signal("changed")
	change_scene()

func change_scene():
	if score >= 500 && onGame2 == false:
		var _target = get_tree().change_scene("res://Game2.tscn")
		print("Level 2")
		onGame2 = true
	if score >= 1000 && onGame2 == true:
		var _target = get_tree().change_scene("res://UI/EndGame.tscn")
		print("Level 2")
