extends Button

func Init(tolevel:int):
	button_down.connect(GameManager.goto_level.bind(tolevel))
	$ColorRect.visible = !GameManager.is_finish_level(tolevel - 1)
	text = str(tolevel)
