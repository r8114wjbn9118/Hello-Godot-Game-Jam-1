class_name WormTail extends Line2D




var length:int = 10
func _init(WorldPos:Vector2, size:int, length:float) -> void:
	var arr = []
	for i in range(size):
		arr.append(WorldPos)
	self.length = length
	joint_mode = LINE_JOINT_ROUND
	points = arr
	modulate = Color("c43b77")
	width = 20.0

func setHead( WorldPos:Vector2 )-> void:
	points[0] = WorldPos

var _time = 0.0
func _process(delta: float) -> void:
	var arr = points.duplicate()
	for i in range(1, arr.size()):
		if (arr[i] - arr[i-1]).length() >= length:
			arr[i] = (arr[i] - arr[i-1]).normalized()* length + arr[i-1]
			arr[i] = align_to_grid_line(arr[i])  # 僅在容許範圍內時才更新為對齊的結果
	# 將節點位置對齊到網格
	points = arr

var GRID_SIZE: Vector2 = Vector2(100, 100)  # 假設網格大小為100x100
var GRID_OFFSET: Vector2 = Vector2(80, 70)  # 網格偏移
var MAX_DISTANCE: float = 45.0  # 容許距離
func align_to_grid_line(pos: Vector2) -> Vector2: # 對齊到網格線上 容許距離
	# 計算當前與前一節點的本地坐標
	var local_end = pos - GRID_OFFSET
	var new_pos:Vector2 = pos
	var grid = Vector2(
		floor(local_end.x / GRID_SIZE.x) * GRID_SIZE.x,
		floor(local_end.y / GRID_SIZE.y) * GRID_SIZE.y
	) + GRID_OFFSET + GRID_SIZE/2.0
	if (pos-grid).length() <= MAX_DISTANCE:
		new_pos = grid+ (pos-grid).normalized() * MAX_DISTANCE
	return new_pos
