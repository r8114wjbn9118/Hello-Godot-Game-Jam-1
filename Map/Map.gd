class_name Map extends Node2D 

@export var size:Vector2i = Vector2i(7,7)

var _undo_redo = UndoRedo.new() # 命令模式

func Build(size:Vector2i, points:Array[Vector2i]): #初始化
	pass

func Do(vec:Vector2i):
	pass
func Reset():
	pass
func Undo():
	pass
func Redo():
	pass


func _scan_nodes(): 
	pass
func _scan_warm_nodes():
	pass
func _scan_eye_nodes():
	pass


class Point:
	pass
class Edge:
	pass









#
