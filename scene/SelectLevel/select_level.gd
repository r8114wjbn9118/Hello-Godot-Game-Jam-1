extends Control

@export var max_row_count = 10
@export var button:PackedScene

var select_index = 1
var button_list: = [null]

func _ready() -> void:
	select_index = GameManager.get_last_level()
	
	var target = $Panel/VBoxContainer
	var child
	for i in range(1, GameManager.get_available_level() + 1):
		if i % max_row_count == 1:
			child = HBoxContainer.new()
			target.add_child(child)
			
		var node = button.instantiate()
		node.Init(i)
		button_list.append(node)
		child.add_child(node)
		
		change_select_target(0)
	

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_pressed("ui_up"):
		change_select_target(-max_row_count)
	elif Input.is_action_pressed("ui_left"):
		change_select_target(-1)
	elif Input.is_action_pressed("ui_right"):
		change_select_target(1)
	elif Input.is_action_pressed("ui_down"):
		change_select_target(max_row_count)
	elif Input.is_action_pressed("ui_accept"):
		go_level()
	elif Input.is_action_pressed("ui_cancel"):
		back()
	
func change_select_target(n:int):
	var target = select_index + n
	if target > 0 and target < button_list.size():
		button_list[select_index].selected = false
		select_index = target
		button_list[select_index].selected = true
	else:
		## 發出失敗音效
		pass

func go_level():
	var button = button_list[select_index]
	printt(button, button.target_level, button.can_select)
	if button.can_select:
		button.go_level()
	else:
		## 發出失敗音效
		pass
	
func back():
	GameManager.goto_scene("title")



func _on_title_button_button_down() -> void:
	back()
