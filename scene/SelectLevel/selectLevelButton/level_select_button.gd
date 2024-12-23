extends Button

var target_level = 0
var selected = false
var can_select = false

func Init(tolevel:int):
	target_level = tolevel
	button_down.connect(go_level)
	can_select = GameManager.is_finish_level(tolevel - 1)
	$ColorRect.visible = not can_select
	text = str(tolevel)

func go_level():
	if can_select:
		GameManager.goto_level(target_level)
	else:
		## 發出失敗音效
		pass
