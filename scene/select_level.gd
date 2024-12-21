extends Node2D



func _ready() -> void:
	var target = $CanvasLayer/Control/Panel/HFlowContainer
	for i in range(1, GameManager.get_available_level()+1):
		var node = preload("res://scene/selectLevelButton/LevelSelectButton.tscn")\
			.instantiate()
		node.Init(i, (i-1) in GameManager.GetFinishedLevel())
		target.add_child(node)
	
