extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func Init(tolevel:int, available:bool):
	button_down.connect(GameManager.goto_level.bind(tolevel))
	$ColorRect.visible = !available
	text = str(tolevel)
