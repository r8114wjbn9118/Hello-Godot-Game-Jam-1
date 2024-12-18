@tool
extends TileMapLayer
class_name EdgeManager

func _ready() -> void:
	clear()

func get_connect_point_list(point_list:Array[Vector2i]) -> Array:
	var list:Array = []
	if point_list.size() > 1:
		for i in range(point_list.size() - 1):
			var p1:Vector2i = point_list[i]
			for j in range(i + 1, point_list.size()):
				var p2:Vector2i = point_list[j]
				var distance:int = abs(p1.x - p2.x) + abs(p1.y - p2.y)
				if distance == 1:
					list.append([p1, p2])
	return list



#region 廢棄
#var child_tscn:Resource = load("res://MapItems/Edge.tscn")
#func Build(size, start_pos, margin, spacing):
	#print("Build Edge")
	##[垂直線, 水平線]
#
	#for y in range(size.y):
		#var v_list = []
		#var h_list = []
		#for x in range(size.x):
			## 垂直線
			#if y < size.y - 1:
				#var node = Build_node(start_pos, Vector2i(x, y), spacing, Vector2i.DOWN)
				#v_list.append(node)
			## 水平線
			#if x < size.x - 1:
				#var node = Build_node(start_pos, Vector2i(x, y), spacing, Vector2i.RIGHT)
				#h_list.append(node)
		#
	#print()
#
#func Build_node(start_pos, game_pos, spacing, direction):
	#var start_point:Vector2i = start_pos + spacing * game_pos
	#var end_point:Vector2i = start_point + spacing * direction
	#
	#var point_pos:PackedVector2Array = PackedVector2Array([start_point, end_point])
	#
	#var new_node:Node2D = child_tscn.instantiate()
	#new_node.initialize(game_pos, point_pos, direction)
	#
	#add_child(new_node)
	#
	#return new_node
#endregion
