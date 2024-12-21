extends Node2D
class_name Manager

var manager_node:Node2D
var list:Array

func Build(size, start_pos, margin, spacing):
	pass
	
func clear_child():
	if not manager_node:
		return
		
	for child in manager_node.get_children():
		child.queue_free()


#func get_pos_node_V1(x:int):
	#return list[x]
func get_pos_node_V2(game_pos:Vector2i):
	return list[game_pos.y][game_pos.x]
func get_pos_node_V3(game_pos:Vector3i):
	return list[game_pos.z][game_pos.y][game_pos.x]

func get_disnace(a, b):
	return abs(a.x - b.x) + abs(a.y - b.y)
