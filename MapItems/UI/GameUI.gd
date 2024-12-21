class_name GameUI extends CanvasLayer
func EndAnimeStart():
	EndAnimeEnd.emit()
signal EndAnimeEnd






#


func _on_button_button_down() -> void: ## goto level
	GameManager.goto_level(int($Control/DEBUGPanel/TextEdit.text))


func _on_reset_data_button_button_down() -> void:
	GameManager.reset_save_data()
