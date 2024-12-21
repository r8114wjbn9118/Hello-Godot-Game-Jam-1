extends Control

@export var button:PackedScene

func _ready() -> void:
	SoundManager.play_BGM(SoundManager.BGM.IN_GAME)
	
	var target = $Panel/VBoxContainer
	var child
	
	for i in range(1, GameManager.get_available_level() + 1):
		if i % 10 == 1:
			child = HBoxContainer.new()
			target.add_child(child)
		var node = button.instantiate()
		node.Init(i)
		child.add_child(node)
