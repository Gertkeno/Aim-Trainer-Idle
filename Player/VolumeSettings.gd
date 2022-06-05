extends VBoxContainer

func _ready() -> void:
	for child in self.get_children():
		var slider := child.get_node('HSlider') as HSlider
		slider.connect("value_changed", self, "_on_value_changed", [ child.get_name() ])

func _on_value_changed(value: float, statname: String) -> void:
	Settings.set(statname, value)
