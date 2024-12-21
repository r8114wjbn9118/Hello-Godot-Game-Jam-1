class_name GameUI extends CanvasLayer


func EndAnimeStart():
	EndAnimeEnd.emit()
signal EndAnimeEnd

@onready var fg = %Foreground
@onready var input = %Input

var fg_img:
	set(target):
		if target is GameManager.FG_TYPE:
			fg.texture = GameManager.get_fg_img(target)
		elif target is Texture2D:
			fg.texture = target
		elif target is String and target:
			fg.texture = load(target)
	get: return fg.texture if fg else null

func init(level, fg_img):
	input.value = level
	self.fg_img = fg_img
#


func _on_button_button_down() -> void: ## goto level
	GameManager.goto_level(input.value)


func _on_reset_data_button_button_down() -> void:
	GameManager.reset_save_data()
