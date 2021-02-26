extends Node2D

export (String) var color
var is_matched
var target_position = Vector2(0,0)

func move_piece(change):
	target_position = position + change
	position = target_position

