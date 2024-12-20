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
@export var spacing:Vector2i = Vector2i.ONE * 100
var old_spacing:Vector2i
#endregion

#region 變量(遊戲)
@export_group("遊戲")

@export_subgroup("目標")
## 最大檢測範圍(-1=無限).
## 從眼(Eye)開始檢查(-1)四個方向的邊, 如果不是關閉的, 則再次檢查(-1)未關閉方向位置的邊.
## 直到所有邊完全關閉(完成關卡)或次數用盡
@export_range(-1, 1000) var max_check_finish_distance:int = -1

@export_subgroup("角色")
## 移動速度
@export_range(0, 1000) var move_speed:int = 200
## 移動距離(-1=無限)
@export_range(-1, 1000) var max_move_distance:int = 7
#endregion

#region node
@onready var point_manager = %Point
@onready var h_edge_manager = %HEdge
@onready var v_edge_manager = %VEdge
@onready var eye_manager = %Eye
@onready var worm_manager = %Worm
#endregion

var timer:float = 0.0 # update timer
var main_worm_pos:Vector2
var sub_worm_pos:Vector2
var main_worm_rotate:float
var sub_worm_rotate:float

func _ready():
	update() ## WARNING 必須更新一次, 否則可能會出現問題

	if Engine.is_editor_hint():
		main_worm_rotate = worm_manager.main_worm.rotation
	else:
		worm_manager.initialize(move_speed, max_move_distance)
		worm_manager.move_finish_signal.connect(_on_worm_move_finish)

	# 太大擋住畫面, 編輯時先關閉
	%Foreground.visible = not Engine.is_editor_hint()

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		timer += delta
		if timer > .5:
			timer = 0
			update()
#region 地圖編輯器

func update():
	update_tile()
	update_child()

func update_tile():
	if auto_margin != old_auto_margin \
	or margin != old_margin \
	or spacing != old_spacing:
		## 編輯器的畫面不等於遊戲畫面大小, 需要用設定的大小調整位置
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

		## 可能需要增加對scale的調整
		#

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
	# 地圖更新
	if point_manager.need_update_child():
		#point_manager.update_childs()
		var point_list:Array[Vector2i] = point_manager.list

		h_edge_manager.update_child(point_list)
		v_edge_manager.update_child(point_list)
		eye_manager.update_child(point_list)
		
	# 頭(Worm)吸附點(Point)
	var main_worm = worm_manager.main_worm
	var sub_worm = worm_manager.sub_worm
	if main_worm_pos != worm_manager.main_worm.position \
	or sub_worm_pos != worm_manager.sub_worm.position:
		worm_manager.init_pos()

		main_worm_pos = worm_manager.main_worm.position
		sub_worm_pos = worm_manager.sub_worm.position
	
	# 同步轉頭
	if main_worm_rotate != worm_manager.main_worm.rotation:
		sub_worm.rotation = main_worm.rotation + PI
	elif sub_worm_rotate != worm_manager.sub_worm.rotation:
		main_worm.rotation = sub_worm.rotation + PI
	main_worm_rotate = worm_manager.main_worm.rotation
	sub_worm_rotate = worm_manager.sub_worm.rotation
#endregion


## 廣度搜尋, 以每個眼(Eye)為起點開始檢查邊是否已完成
func check_finish():
	var eye_game_pos_list:Array[Vector2i] = eye_manager.get_game_pos_list()
	var space_game_pos_list:Array[Vector2i] = eye_manager.get_used_cells()
	var h_closed_edge:Array[Vector2i] = h_edge_manager.get_closed_edge()
	var v_closed_edge:Array[Vector2i] = v_edge_manager.get_closed_edge()

	var eye_finish_list:Array[Vector2i] = []
	for eye_game_pos in eye_game_pos_list:
		if eye_game_pos in eye_finish_list:
			continue

		var h_checked_edge_list:Array[Vector2i] = []
		var v_checked_edge_list:Array[Vector2i] = []
		var need_check_list:Array[Vector2i] = [eye_game_pos]

		var check_count:int = 0
		while check_count < max_check_finish_distance \
		or max_check_finish_distance < 0:
			check_count += 1

			var new_need_check_list:Array[Vector2i] = []
			for pos in need_check_list:
				# 這位置是眼(Eye), 加入完成列表防止重複檢查
				if pos in eye_game_pos_list:
					eye_finish_list.append(pos)

				## 上/左的面和線位置稍微有點不同, 再想想有沒有方法壓成一個func

				# 上
				if not pos in h_closed_edge \
				and not pos in h_checked_edge_list:
					if not (pos + Vector2i.UP) in space_game_pos_list:
						return false
					if not pos in h_checked_edge_list:
						h_checked_edge_list.append(pos)
					if not (pos + Vector2i.UP) in new_need_check_list:
						new_need_check_list.append(pos + Vector2i.UP)

				# 下
				if not (pos + Vector2i.DOWN) in h_closed_edge \
				and not (pos + Vector2i.DOWN) in h_checked_edge_list:
					if not (pos + Vector2i.DOWN) in space_game_pos_list:
						return false
					if not (pos + Vector2i.DOWN) in h_checked_edge_list:
						h_checked_edge_list.append(pos + Vector2i.DOWN)
					if not (pos + Vector2i.DOWN) in new_need_check_list:
						new_need_check_list.append(pos + Vector2i.DOWN)

				# 左
				if not pos in v_closed_edge \
				and not pos in v_checked_edge_list:
					if not (pos + Vector2i.LEFT) in space_game_pos_list:
						return false
					if not pos in v_checked_edge_list:
						v_checked_edge_list.append(pos)
					if not (pos + Vector2i.LEFT) in new_need_check_list:
						new_need_check_list.append(pos + Vector2i.LEFT)

				# 右
				if not (pos + Vector2i.RIGHT) in v_closed_edge \
				and not (pos + Vector2i.RIGHT) in v_checked_edge_list:
					if not (pos + Vector2i.RIGHT) in space_game_pos_list:
						return false
					if not (pos + Vector2i.RIGHT) in v_checked_edge_list:
						v_checked_edge_list.append(pos + Vector2i.RIGHT)
					if not (pos + Vector2i.RIGHT) in new_need_check_list:
						new_need_check_list.append(pos + Vector2i.RIGHT)

			# 下一輪搜索的目標. 如果無目標則為己完成, 開始檢查下一個眼(Eye)
			need_check_list = new_need_check_list
			if need_check_list.is_empty():
				break

		# 搜索次數用盡但沒完成包圍
		if not need_check_list.is_empty():
			return false
	return true

func _on_worm_move_finish():
	print("Worm Move Finish")
	if check_finish():
		print("Game Finish")





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
