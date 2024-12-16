extends Manager
#class_name PlaneManager

var child_tscn:Resource = load("res://MapItems/Plane.tscn")

func Build(size, start_pos, margin, spacing):
	print("Build Plane")
	list = []
	
	for y in range(size.y - 1):
		var x_list:Array = []
		for x in range(size.x - 1):
			var game_pos = Vector2i(x, y)
			var spacing_vec:Vector2i = spacing * game_pos
			
			var position:Vector2i = start_pos + spacing_vec
			
			var new_node:Node2D = child_tscn.instantiate()
			new_node.initialize(game_pos, position, spacing)
			#printt(x, y, new_node.name, new_node.position, new_node)
			
			self.add_child(new_node)
			
			x_list.append(new_node)
		list.append(x_list)
	print()



func get_pos_node(vec):
	return get_pos_node_V2(vec)
