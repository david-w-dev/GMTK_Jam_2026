extends Control
class_name EndScreen

signal new_game_started

func set_text(text: String) -> void:
	$Button.text = text + "\nclick to play again"


func _on_button_pressed() -> void:
	new_game_started.emit()
