class_name GameUI extends CanvasLayer

signal move_input

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

func init(fg_img):
	input.value = GameManager.current_level
	self.fg_img = fg_img
	%Level.text = "[center][font_size=20][color=green]Level "+str(input.value)+"[/color][/font_size][/center]"

func _ready() -> void:
	## TEST
	%InputPanel.visible = not OS.get_model_name() != "GenericDevice"


func _on_button_button_down() -> void: ## goto level
	GameManager.goto_level(input.value)


func _on_reset_data_button_button_down() -> void:
	GameManager.reset_save_data()


func _on_level_select_button_button_down() -> void:
	GameManager.goto_scene("select")


#region 觸控輸入

func _on_up_button_down() -> void:
	move_input.emit("up")

func _on_left_button_down() -> void:
	move_input.emit("left")

func _on_down_button_down() -> void:
	move_input.emit("down")

func _on_right_button_down() -> void:
	move_input.emit("right")

func _on_undo_button_down() -> void:
	move_input.emit("undo")

#endregion
