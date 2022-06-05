extends HSlider

onready var sample := $AudioStreamPlayer as AudioStreamPlayer

func _on_HSlider_value_changed(_value: float) -> void:
	if not sample.playing:
		sample.play()
