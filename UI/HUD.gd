extends Control

func _ready():
	var _changed = Global.connect("changed",self,"_on_score_changed")
	_on_score_changed()

func _on_score_changed():
	$Score.text = ": " + str(Global.score)
	if Global.onGame2 == false:
		$NextLevel.text = "Score Till Level 2: " + str(500 - Global.score)
	if Global.onGame2 == true:
		$NextLevel.text = "Score Till End Of Game: " + str(1000 - Global.score)
