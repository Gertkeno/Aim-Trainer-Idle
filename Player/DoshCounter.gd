extends Label

export (String) var statName: String
export (String) var currencyPostfix: String

func _process(_delta: float) -> void:
	text = str(round(Stats.get(statName))) + currencyPostfix
