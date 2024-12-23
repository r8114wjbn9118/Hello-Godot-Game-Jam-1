extends Control

@export var max_row_count = 10
@export var button:PackedScene

func _ready() -> void:
	var select = GameManager.get_last_level()
	
	var target = $Panel/VBoxContainer
	var child
	for i in range(1, GameManager.get_available_level() + 1):
		if i % max_row_count == 1:
			child = HBoxContainer.new()
			target.add_child(child)
		
		var node = button.instantiate()
		node.Init(i)
		child.add_child(node)
		if i == select:
			node.grab_focus()


func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_pressed("ui_cancel"):
		back()

func back():
	GameManager.goto_scene("title")



func _on_title_button_button_down() -> void:
	back()
