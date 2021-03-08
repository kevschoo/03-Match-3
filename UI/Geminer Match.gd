extends Sprite


# Declare member variables here. Examples:
#var top = 300

var top = Vector2(288,300)
var bot = Vector2(288,280)

# Called when the node enters the scene tree for the first time.
func _ready():
	$Tween.interpolate_property(self, "position", position, bot, 3, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	$Tween.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if position.y == 300:
		$Tween.interpolate_property(self, "position", position, bot, 3, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
		$Tween.start()
	if position.y == 280:
		$Tween.interpolate_property(self, "position", position, top, 3, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
		$Tween.start()
