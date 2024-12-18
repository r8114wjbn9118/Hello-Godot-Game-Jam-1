@tool
extends TileMapLayer
class_name EyeManager

enum TYPE {
	NULL,
	SPACE,
	EYE
}
var coords_type:Dictionary = {
	Vector2i(0,0): TYPE.SPACE,
	Vector2i(0,3): TYPE.EYE
}

var list:Array = []
var eye_game_pos_list:Array = []

func update_child(point_list:Array[Vector2i]):
	var new_list:Array[Vector2i] = []
	
	eye_game_pos_list = get_game_pos_list()
	
	for point in point_list:
		if point in eye_game_pos_list:
			continue

		if not (point + Vector2i.ONE) in point_list:
			continue
		if not (point + Vector2i.RIGHT) in point_list:
			continue
		if not (point + Vector2i.DOWN) in point_list:
			continue
		
		create_cell(point)
		new_list.append(point)
		
	for p in list:
		if not p in new_list:
			erase_cell(p)
			
	list = new_list
	return

func create_cell(vec:Vector2i):
	set_cell(vec, 1, Vector2i(0, 0))


func get_game_pos_list():
	var list:Array[Vector2i] = []
	var used_cell_list:Array[Vector2i] = get_used_cells()
	for pos in used_cell_list:
		var pos_type:TYPE = coords_type.get(get_cell_atlas_coords(pos))
		if pos_type == TYPE.EYE:
			list.append(pos)
	return list



#region 廢棄
#var child_tscn:Resource = load("res://MapItems/Plane.tscn")
#
#func Build(size, start_pos, margin, spacing):
	#print("Build Plane")
	#
	#for y in range(size.y - 1):
		#var x_list:Array = []
		#for x in range(size.x - 1):
			#var game_pos = Vector2i(x, y)
			#var spacing_vec:Vector2i = spacing * game_pos
			#
			#var pos:Vector2i = start_pos + spacing_vec
			#
			#var new_node:Node2D = child_tscn.instantiate()
			#new_node.initialize(game_pos, pos, spacing)
			##printt(x, y, new_node.name, new_node.position, new_node)
			#
			#add_child(new_node)
			#
			#x_list.append(new_node)
	#print()
#endregion
