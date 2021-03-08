extends Node2D
onready var global = get_node("/root/Global")
export (String) var color
var is_matched
var is_counted
var selected = false
var target_position = Vector2(0,0)
var default_modulate = Color(1,1,1,1)
var highlight = Color(0.6,0.6,0.6,1)
export var appear_speed = 3
export var fall_speed = 1.0
export var rotate_speed = 1.0

var dying = false
onready var textures = [
	load("res://Assets/sparkle.png")
	,load("res://Assets/largeSparkle.png")
]

func _ready():
	default_modulate = modulate


func _physics_process(_delta):
	if dying and not $Particles2D.emitting and not $Tween.is_active():
		queue_free()
	
	if selected:
		if modulate != highlight:
			modulate = highlight
			emit_particle(position)
			$Particles2D.emitting = true
	else:
		if modulate != default_modulate:
			modulate = default_modulate
			$Particles2D.emitting = false

func move_piece(change):
	target_position = position + change
	position = target_position

func die():
	dying = true;
	var fall_duration = randf()*fall_speed + 1
	var rotate_amount = (randi() % 1440) - 720
	var target_pos = position
	target_pos.y = 1000
	$Tween.interpolate_property(self, "position", position, target_pos, fall_duration, Tween.TRANS_CUBIC, Tween.EASE_IN)
	$Tween.start()
	$Tween.interpolate_property(self, "rotation_degrees", rotation_degrees, rotate_amount, fall_duration-0.25, Tween.TRANS_QUINT, Tween.EASE_IN)
	$Tween.start()
	if $Sprite.spriteName == "Blue":
		global.blue += 1
	if $Sprite.spriteName == "Green":
		global.green += 1
	if $Sprite.spriteName == "Red":
		global.red += 1
	if $Sprite.spriteName == "White":
		global.white += 1
	
		
func emit_particle(pos):
	$Particles2D.texture = textures[randi() % textures.size()]
	$Particles2D.emitting = true
	$Particles2D.global_position = pos



