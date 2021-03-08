extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var pick = load("res://Assets/pick.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_custom_mouse_cursor(pick)	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
