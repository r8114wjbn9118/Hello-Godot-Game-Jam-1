@tool
extends TileMapLayer
class_name PointManager

var list = []

func need_update_child() -> bool:
	var new_list = get_used_cells()
	if new_list.size() == list.size():
		for i in list.size():
			if new_list[i] != list[i]:
				break
		return false
	list = new_list
	return true

func update_child():
	return
	


func get_point_game_pos(pos):
	return local_to_map(pos - position)

func get_point_position(pos):
	return map_to_local(pos) + position
	
func get_point_center_pos(pos):
	return get_point_position(get_point_game_pos(pos))



#region 廢棄
#func Build(size, start_pos, margin, spacing):
	#print("Build Point")
	#list = []
	#
	#for y in range(size.y):
		#var x_list:Array = []
		#for x in range(size.x):
			#var game_pos = Vector2i(x, y)
			#var spacing_vec:Vector2i = spacing * game_pos
			#
			#var position:Vector2i = start_pos + spacing_vec
			#
			#var new_node:Node2D = child_tscn.instantiate()
			#new_node.initialize(game_pos, position)
			##printt(x, y, new_node.name, new_node.position, new_node)
			#
			#add_child(new_node)
			#
			#x_list.append(new_node)
		#list.append(x_list)
	#print()
#endregion
