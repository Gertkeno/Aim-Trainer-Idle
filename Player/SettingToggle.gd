extends Control

func _on_CheckBox_toggled(button_pressed: bool) -> void:
	($Control as Control).visible = button_pressed
	($Money as Control).visible = not button_pressed
