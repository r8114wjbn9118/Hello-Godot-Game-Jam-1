@tool
extends Node2D

@onready var line = %Line2D

var need_update = true
var old_points

var points:
	set(value): line.points = value
	get: return line.points

func start_move():
	need_update = true

func _ready() -> void:
	var list = []
	for i in range(3):
		list.append(Vector2.ZERO)
	points = list
	old_points = points


var _moving:bool = false
var canMove:bool = true

const LENGTH = 15.0
const STEP_LENGTH = 15.0 # 10
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if need_update:
		$Node.global_position = Vector2.ZERO
		$Node.global_rotation = 0.0
		update()
		if points == old_points:
			need_update = false
		old_points = points
		
func update():
	var StartAt:Vector2 = global_position
	var EndAt:Vector2 = %LegEnd.global_position
	if not _moving and canMove:
		if (%LegEnd.global_position - %Target.global_position).length() > STEP_LENGTH: # 重置落腳點
			_moving = true
			var tween = create_tween()
			tween.tween_property(%LegEnd, "global_position", %Target.global_position, 0.01)
			tween.tween_interval(0.01)
			tween.tween_property(self, "_moving", false, 0.0)
			#%LegEnd.global_position = %Target.global_position
		
	for i in range(3):
		FABRIK_F(StartAt)
		FABRIK_I(EndAt)
		FABRIK_F(StartAt)

	
func FABRIK_F(pos:Vector2):  # 正向
	var arr:PackedVector2Array = points
	arr[0] = pos
	for i in range(1, arr.size()):
		#if (arr[i] - arr[i-1]).length() > LENGTH:
		arr[i] = (arr[i] - arr[i - 1]).normalized() * LENGTH + arr[i - 1]
	points = arr

func FABRIK_I(pos:Vector2):  # 反向
	var arr:PackedVector2Array = points
	arr[-1] = pos
	for i in range(arr.size() - 2, -1, -1): # 反向
		#if (arr[i] - arr[i+1]).length() > LENGTH:
		arr[i] = (arr[i] - arr[i + 1]).normalized() * LENGTH + arr[i + 1]
	points = arr
