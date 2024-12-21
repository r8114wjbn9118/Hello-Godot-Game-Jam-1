@tool
extends EdgeManager
class_name VEdgeManager

func _ready() -> void:
	super._ready()

func update_child(point_list:Array[Vector2i]):
	var new_list = []
	
	var connect_point_list:Array = get_connect_point_list(point_list)
	for connect_point in connect_point_list:
		var p1:Vector2i = connect_point[0]
		var p2:Vector2i = connect_point[1]
		if p1.y == p2.y:
			continue
		if p1.y < p2.y:
			create_cell(p1)
			new_list.append(p1)
		else:
			create_cell(p2)
			new_list.append(p2)
			
	for p in list:
		if not p in new_list:
			erase_cell(p)
	
	list = new_list
	return

func create_cell(vec:Vector2i):
	set_cell(vec, 1, Vector2i(4, 3))

func get_game_pos_from_two_point(game_pos_1, game_pos_2):
	var direction = game_pos_2 - game_pos_1
	if direction == Vector2i.DOWN:
		return game_pos_1
	if abs(direction) == Vector2i.DOWN:
		return game_pos_2
	return null
