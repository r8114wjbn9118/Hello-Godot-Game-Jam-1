extends Manager
#class_name EdgeManager


var child_tscn:Resource = load("res://MapItems/Edge.tscn")


func Build(size, start_pos, margin, spacing):
	print("Build Edge")
	#[垂直線, 水平線]
	list = [[], []]

	for y in range(size.y):
		var v_list = []
		var h_list = []
		for x in range(size.x):
			# 垂直線
			if y < size.y - 1:
				var node = Build_node(start_pos, Vector2i(x, y), spacing, Vector2i.DOWN)
				v_list.append(node)
			# 水平線
			if x < size.x - 1:
				var node = Build_node(start_pos, Vector2i(x, y), spacing, Vector2i.RIGHT)
				h_list.append(node)
		
		list[0].append(v_list)
		list[1].append(h_list)
	printt(list)
	print()

func Build_node(start_pos, game_pos, spacing, direction):
	var start_point:Vector2i = start_pos + spacing * game_pos
	var end_point:Vector2i = start_point + spacing * direction
	
	var point_pos:PackedVector2Array = PackedVector2Array([start_point, end_point])
	
	var new_node:Node2D = child_tscn.instantiate()
	new_node.initialize(game_pos, point_pos, direction)
	
	self.add_child(new_node)
	
	return new_node



func get_pos_node(vec):
	return get_pos_node_V3(vec)
