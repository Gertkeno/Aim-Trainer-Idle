extends Label

func _process(_delta: float) -> void:
	text = "$" + str(round(Stats.playerDosh))
