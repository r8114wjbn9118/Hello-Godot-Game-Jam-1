extends Node
class_name LineManager

var worm
var point_manager:PointManager
var line:Line2D

var color:
	set(value):
		color = value
		if value is Color:
			if line: line.default_color = value

## 最大距離(格子), 在Map更改max_move_distance
var max_distance:int = 8

var points:
	set(value): line.points = value
	get: return line.points

var length:int = 10
func init(worm, point_manager) -> void:
	self.worm = worm
	if point_manager is PointManager:
		self.point_manager = point_manager
		GRID_SIZE = point_manager.tile_set.tile_size
		GRID_OFFSET = point_manager.position + GRID_SIZE / 2

	var arr = []
	var pos = worm.position
	for i in range(length * max_distance):
		arr.append(pos)
	points = arr
	
	move()


## 頭部移動時連帶執行
func move() -> void:
	points[0] = worm.position

	var arr = points
	for i in range(1, arr.size()):
		if (arr[i] - arr[i-1]).length() > length:
			arr[i] = (arr[i] - arr[i-1]).normalized() * length + arr[i-1]
			arr[i] = align_to_grid_line(arr[i])  # 僅在容許範圍內時才更新為對齊的結果
		else:
			## 因為是從上(頭)往下傳遞, 假如某點的距離不足以更改位置, 那往下的點都不會需要更改
			## 直接跳出減少循環帶來的計算量
			break
	# 將節點位置對齊到網格
	points = arr
		

var GRID_SIZE: Vector2 = Vector2.ONE * 100 # 假設網格大小為100x100
var GRID_OFFSET: Vector2 = Vector2(30, 20) + GRID_SIZE / 2 # 網格偏移
var MAX_DISTANCE: float = 45.0  # 容許距離
func align_to_grid_line(pos: Vector2) -> Vector2: # 對齊到網格線上 容許距離
	# 計算當前與前一節點的本地坐標
	var local_end = pos - GRID_OFFSET
	var grid = floor(local_end / GRID_SIZE) * GRID_SIZE + GRID_OFFSET + GRID_SIZE / 2
	
	#var game_pos = point_manager.get_point_game_pos(pos - GRID_SIZE / 2)
	#var grid = point_manager.get_point_position(game_pos) + GRID_SIZE / 2

	if (pos - grid).length() <= MAX_DISTANCE:
		return grid + (pos - grid).normalized() * MAX_DISTANCE
	else:
		return pos
