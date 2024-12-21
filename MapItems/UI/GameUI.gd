class_name GameUI extends CanvasLayer
func EndAnimeStart():
	EndAnimeEnd.emit()
signal EndAnimeEnd






#


func _on_button_button_down() -> void: ## goto level
	GameManager.goto_level(int($Control/DEBUGPanel/TextEdit.text))
