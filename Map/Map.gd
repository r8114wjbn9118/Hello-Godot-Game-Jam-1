class_name Map extends Node2D 

@export var size:Vector2i = Vector2i(7,7)

@onready var point_manager = %Point
@onready var edge_manager = %Edge
@onready var plane_manager = %Plane
@onready var eye_manager = %Eye
@onready var main_worm = %MainWorm
@onready var sub_worm = %SubWorm

func _ready():
	Build()
	main_worm.initialize(size, sub_worm)

func Build(): #size:Vector2i, points:Array[Vector2i]): #初始化
	var max_size:int
	var start_pos:Vector2i = Vector2i.ZERO
	
	var window_size:Vector2i = get_tree().root.size
	if window_size.x > window_size.y:
		max_size = window_size.y
		start_pos.x = floori((window_size.x - max_size) / 2)
		
	else:
		max_size = window_size.x
		start_pos.y = floori((window_size.y - max_size) / 2)
		
	var margin:Vector2i = (Vector2i.ONE * max_size) / (size + Vector2i.ONE * 2)
	start_pos += margin

	var spacing:Vector2i = (Vector2i(max_size, max_size) - margin * 2) / size
	
	printt(window_size, max_size, start_pos, margin, spacing)
	
	edge_manager.Build(size, start_pos, margin, spacing)
	point_manager.Build(size, start_pos, margin, spacing)
	plane_manager.Build(size, start_pos, margin, spacing)
	
#region 測試面對線的連接
	#var plane_node = plane_manager.get_pos_node(Vector2i.ONE)# * i)
	#printt(plane_node, plane_node.edge_game_pos)
	#var edge_game_pos = plane_node.edge_game_pos
	#for k in edge_game_pos.keys():
		#var v = edge_game_pos[k]
		#var en = edge_manager.get_pos_node(v)
		#en.visible = false
		#printt(k, v, en)
		#print()
#endregion
	print()



func check_finish():
	
	pass
