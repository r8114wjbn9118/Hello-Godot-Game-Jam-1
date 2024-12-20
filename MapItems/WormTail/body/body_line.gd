class_name BodyLine extends Node

var point_manager:PointManager

## 身體長度
var max_distance:int = 1

func getPoints():
	return $BodyLine.points
func setPoints(arr):
	$BodyLine.points = arr

func setColor(color:Color):
	var arr := [$LegIk_FR, $LegIk_BL, $LegIk_FL, $LegIk_BR]
	for i in arr:
		i.setColor(color)

@onready var _line = $BodyLine

var length:int = 10
func init(head, _point_manager) -> void:
	
	self.point_manager = _point_manager
	GRID_SIZE = _point_manager.tile_set.tile_size
	GRID_OFFSET = _point_manager.position + GRID_SIZE / 2
	
	#name = head.name + "Body"
	var arr = []
	for i in range(length * max_distance):
		arr.append(head.position)
	_line.points = arr

func setHead(pos)-> void:
	_line.points[0] = pos

## 頭部移動時連帶執行
func move(pos) -> void:
	setHead(pos)
	var arr = _line.points.duplicate()
	for i in range(1, arr.size()):
		if (arr[i] - arr[i-1]).length() > length:
			arr[i] = (arr[i] - arr[i-1]).normalized() * length + arr[i-1]
			arr[i] = align_to_grid_line(arr[i])  # 僅在容許範圍內時才更新為對齊的結果
	# 將節點位置對齊到網格
	_line.points = arr
	
	var curve:Curve2D = $Path2D.curve
	curve.clear_points()
	for i in arr:
		curve.add_point(i)
	const FRONT_POS = 0.2
	const BACK_POS = 0.6
	$Path2D/PathFollow2D.progress_ratio = FRONT_POS
	$LegIk_FR.position = $Path2D/PathFollow2D/RMarker2D.global_position
	$LegIk_FR.rotation = $Path2D/PathFollow2D.global_rotation + PI/2
	$LegIk_FL.position = $Path2D/PathFollow2D/LMarker2D.global_position
	$LegIk_FL.rotation = $Path2D/PathFollow2D.global_rotation - PI/2
	
	$Path2D/PathFollow2D.progress_ratio = BACK_POS
	$LegIk_BR.position = $Path2D/PathFollow2D/RMarker2D.global_position
	$LegIk_BR.rotation = $Path2D/PathFollow2D.global_rotation + PI/2
	$LegIk_BL.position = $Path2D/PathFollow2D/LMarker2D.global_position
	$LegIk_BL.rotation = $Path2D/PathFollow2D.global_rotation - PI/2
	
	

var GRID_SIZE: Vector2  # 假設網格大小為100x100
var GRID_OFFSET: Vector2  # 網格偏移
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



var _time = 0.0
const LEG_SP_MOVE_TIME = 0.1
func _process(delta: float) -> void:
	_time += delta
	var arr := [$LegIk_FR, $LegIk_BL, $LegIk_FL, $LegIk_BR]
	var curr_time = fmod(_time, (LEG_SP_MOVE_TIME*4.0))
	var curr:int = floori(curr_time/LEG_SP_MOVE_TIME)
	for i in arr:
		i.canMove = false
	arr[curr].canMove = true
	
	
	
