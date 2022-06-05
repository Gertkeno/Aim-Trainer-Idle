extends VBoxContainer

func _ready() -> void:
	for child in self.get_children():
		var slider := child.get_node('HSlider') as HSlider
		slider.connect("value_changed", self, "_on_value_changed", [ child.get_name() ])
		_on_value_changed(slider.value, child.get_name())

func _on_value_changed(value: float, statname: String) -> void:
	Settings.set(statname, value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(statname), linear2db(value))
