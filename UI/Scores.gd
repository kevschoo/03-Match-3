extends Label
onready var global = get_node("/root/Global")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	self.text = "Score: " + str(Global.score) + "\nRed Crystals Mined: " + str(Global.red) + "\nBlue Diamonds Mined: " + str(Global.blue) + "\nGreen Ore Mined: " + str(Global.green) +"\nWhite Stones Mined: " + str(global.white) 


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
