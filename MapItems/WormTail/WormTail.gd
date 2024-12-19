#class_name WormTail extends Line2D
#
#var point_manager:PointManager
#
### 最大距離(格子), 在Map更改max_move_distance
#var max_distance:int = 8
#
#var length:int = 10
#func _init(head, max_distance:int, point_manager) -> void:
	#self.max_distance = max_distance
	#
	#self.point_manager = point_manager
	#GRID_SIZE = point_manager.tile_set.tile_size
	#GRID_OFFSET = point_manager.position + GRID_SIZE / 2
	#
	#name = head.name + "Body"
	#var arr = []
	#for i in range(length * max_distance):
		#arr.append(head.position)
	#points = arr
	#joint_mode = LINE_JOINT_ROUND
	#modulate = Color("c43b77")
	#width = 20
#
#func setHead(pos)-> void:
	#points[0] = pos
#
### 頭部移動時連帶執行
#func move(pos) -> void:
	#setHead(pos)
#
	#var arr = points.duplicate()
	#for i in range(1, arr.size()):
		#if (arr[i] - arr[i-1]).length() > length:
			#arr[i] = (arr[i] - arr[i-1]).normalized() * length + arr[i-1]
			#arr[i] = align_to_grid_line(arr[i])  # 僅在容許範圍內時才更新為對齊的結果
	## 將節點位置對齊到網格
	#points = arr
		#
#
#var GRID_SIZE: Vector2  # 假設網格大小為100x100
#var GRID_OFFSET: Vector2  # 網格偏移
#var MAX_DISTANCE: float = 45.0  # 容許距離
#func align_to_grid_line(pos: Vector2) -> Vector2: # 對齊到網格線上 容許距離
	## 計算當前與前一節點的本地坐標
	#var local_end = pos - GRID_OFFSET
	#var grid = floor(local_end / GRID_SIZE) * GRID_SIZE + GRID_OFFSET + GRID_SIZE / 2
	#
	##var game_pos = point_manager.get_point_game_pos(pos - GRID_SIZE / 2)
	##var grid = point_manager.get_point_position(game_pos) + GRID_SIZE / 2
#
	#if (pos - grid).length() <= MAX_DISTANCE:
		#return grid + (pos - grid).normalized() * MAX_DISTANCE
	#else:
		#return pos
