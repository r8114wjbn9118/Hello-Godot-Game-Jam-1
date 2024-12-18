@tool
extends Node2D
class_name Map

#region 變量(場景編輯)
@export_group("場景編輯")
## 根據點(Point)的最大可放置數量自動調整邊距(功能受到下列的Margin和Spacing影響)
@export var auto_margin:bool = true
var old_auto_margin
## 調整邊距
@export var margin:Vector2i = Vector2i(0, 0)
var old_margin:Vector2i
## 面(Eye)的大小, 以此同時控制線(VEdge/HEdge)和點(Point)的大小和位置
@export var spacing:Vector2i = Vector2i(50, 50)
var old_spacing:Vector2i
#endregion

#region 變量(遊戲)
@export_group("遊戲")

@export_subgroup("目標")
## 最大檢測範圍(-1=無限).
## 從眼(Eye)開始檢查(-1)四個方向的邊, 如果不是關閉的, 則再次檢查(-1)未關閉方向位置的邊.
## 直到所有邊完全關閉(完成關卡)或次數用盡
@export_range(-1, 1000) var max_check_finish_distance = -1

@export_subgroup("角色")
## 移動速度
@export var move_speed:float = 1
## 移動距離(-1=無限)
@export_range(-1, 1000) var max_move_distance:int = -1
#endregion

#region node
@onready var point_manager = %Point
@onready var h_edge_manager = %HEdge
@onready var v_edge_manager = %VEdge
@onready var eye_manager = %Eye
@onready var worm_manager = %Worm
#endregion

var timer:float = 0.0
var main_worm_pos:Vector2
var sub_worm_pos:Vector2

func _ready():
	update()

	worm_manager.initialize(max_move_distance)
	if not Engine.is_editor_hint():
		worm_manager.move_finish_signal.connect(_on_worm_move_finish)

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		timer += delta
		if timer > .5:
			timer = 0
			update()

func update():
	update_tile()
	update_child()

func update_tile():
	if auto_margin != old_auto_margin \
	or margin != old_margin \
	or spacing != old_spacing:
		var window_size:Vector2i = Vector2i(
			ProjectSettings.get_setting("display/window/size/viewport_width"),
			ProjectSettings.get_setting("display/window/size/viewport_height")
		)
		var start_pos:Vector2i = margin
		# 根據點(Point)的最大可放置數量自動調整邊距, 盡量保持置中
		if auto_margin:
			start_pos = (window_size - (spacing * floor((window_size - margin) / spacing))) / 2

		point_manager.tile_set.tile_size = spacing
		h_edge_manager.tile_set.tile_size = spacing
		v_edge_manager.tile_set.tile_size = spacing
		eye_manager.tile_set.tile_size = spacing

		point_manager.position = start_pos
		h_edge_manager.position = start_pos
		h_edge_manager.position.x += spacing.x / 2
		v_edge_manager.position = start_pos
		v_edge_manager.position.y += spacing.y / 2
		eye_manager.position = start_pos + spacing / 2

		old_auto_margin = auto_margin
		old_margin = margin
		old_spacing = spacing

func update_child():
	if point_manager.need_update_child():
		#point_manager.update_childs()

		var point_list:Array[Vector2i] = point_manager.list
		h_edge_manager.update_child(point_list)
		v_edge_manager.update_child(point_list)
		eye_manager.update_child(point_list)
	
	if main_worm_pos != worm_manager.main_worm.position \
	or sub_worm_pos != worm_manager.sub_worm.position:
		worm_manager.init_pos()
		
		main_worm_pos = worm_manager.main_worm.position
		sub_worm_pos = worm_manager.sub_worm.position



func check_finish():
	var eye_game_pos_list:Array[Vector2i] = eye_manager.get_game_pos_list()
	var space_game_pos_list:Array[Vector2i] = eye_manager.get_used_cells()
	var h_worm_move_path:Array[Vector2i] = worm_manager.get_move_path_h()
	var v_worm_move_path:Array[Vector2i] = worm_manager.get_move_path_v()

	var eye_finish_list:Array[Vector2i] = []
	for eye_game_pos in eye_game_pos_list:
		if eye_game_pos in eye_finish_list:
			continue

		var h_checked_edge_list:Array[Vector2i] = []
		var v_checked_edge_list:Array[Vector2i] = []
		var need_check_list:Array[Vector2i] = [eye_game_pos]
		for check_count in max_check_finish_distance:
			var new_need_check_list:Array[Vector2i] = []
			for pos in need_check_list:
				if pos in eye_game_pos_list:
					eye_finish_list.append(pos)

				# 上
				if not pos in h_worm_move_path:
					if not (pos + Vector2i.UP) in space_game_pos_list:
						return false
					h_checked_edge_list.append(pos)
					new_need_check_list.append(pos + Vector2i.UP)

				# 下
				if not (pos + Vector2i.DOWN) in h_worm_move_path:
					if not (pos + Vector2i.DOWN) in space_game_pos_list:
						return false
					h_checked_edge_list.append(pos + Vector2i.DOWN)
					new_need_check_list.append(pos + Vector2i.DOWN)

				# 左
				if not pos in v_worm_move_path:
					if not (pos + Vector2i.LEFT) in space_game_pos_list:
						return false
					v_checked_edge_list.append(pos)
					new_need_check_list.append(pos + Vector2i.LEFT)

				# 右
				if not (pos + Vector2i.RIGHT) in v_worm_move_path:
					if not (pos + Vector2i.RIGHT) in space_game_pos_list:
						return false
					v_checked_edge_list.append(pos + Vector2i.RIGHT)
					new_need_check_list.append(pos + Vector2i.RIGHT)

			if not new_need_check_list.is_empty():
				need_check_list = new_need_check_list
		if not need_check_list.is_empty():
			return false

func _on_worm_move_finish():
	print("Worm Move Finish")
	check_finish()





#region 廢棄
#func Build(): #size:Vector2i, points:Array[Vector2i]): #初始化
	#var max_size:int
	#var start_pos:Vector2i = Vector2i.ZERO
	#
	#var window_size:Vector2i = get_tree().root.size
	#if window_size.x > window_size.y:
		#max_size = window_size.y
		#start_pos.x = floori((window_size.x - max_size) / 2)
		#
	#else:
		#max_size = window_size.x
		#start_pos.y = floori((window_size.y - max_size) / 2)
		#
	#var margin:Vector2i = (Vector2i.ONE * max_size) / (size + Vector2i.ONE)
	#start_pos += margin
#
	#var spacing:Vector2i = (Vector2i(max_size, max_size) - margin) / size
	#
	#printt(window_size, max_size, start_pos, margin, spacing)
	#
	#edge_manager.Build(size, start_pos, margin, spacing)
	#point_manager.Build(size, start_pos, margin, spacing)
	#plane_manager.Build(size, start_pos, margin, spacing)
	#eye_manager.Build()
#endregion
