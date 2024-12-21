@tool
extends TileManager
class_name EdgeManager

var max_available_count = 2

var list = []
var available_count_dict:Dictionary = {}

func _ready() -> void:
		init_available_count()

# 初始化路徑的可用次數(目前固定為1)
func init_available_count():
	available_count_dict.clear()
	var cell_list:Array[Vector2i] = get_used_cells()
	for cell in cell_list:
		available_count_dict[cell] = 0
	return available_count_dict


func get_closed_edge():
	var _list:Array[Vector2i] = []
	for key in available_count_dict.keys():
		if get_available_count(key) > 0:
			_list.append(key)
	return _list

func get_available_count(game_pos):
	return available_count_dict.get(game_pos, -1)

func change_available_count(game_pos, n):
	if not is_passable(game_pos, n):
		return false	
	available_count_dict[game_pos] = get_available_count(game_pos) + n
	return true

func is_passable(game_pos, n = 1):
	var available_count = get_available_count(game_pos) + n
	if max_available_count < 0:
		return true
	if clamp(available_count, 0, max_available_count) == available_count:
		return true
	return false



func get_game_pos_from_two_point(game_pos_1, game_pos_2):
	pass

func get_connect_point_list(point_list:Array[Vector2i]) -> Array:
	var _list:Array = []
	if point_list.size() > 1:
		for i in range(point_list.size() - 1):
			var p1:Vector2i = point_list[i]
			for j in range(i + 1, point_list.size()):
				var p2:Vector2i = point_list[j]
				var distance:int = abs(p1.x - p2.x) + abs(p1.y - p2.y)
				if distance == 1:
					_list.append([p1, p2])
	return _list



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
