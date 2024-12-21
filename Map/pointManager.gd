@tool
extends TileManager
class_name PointManager

func update_child():
	return
	





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
