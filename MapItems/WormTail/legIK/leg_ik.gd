@tool
extends Node2D


const LENGTH = 15.0
const STEP_LENGTH = 10.0
# Called every frame. 'delta' is the elapsed time since the previous frame.
var _moving:bool = false
var canMove:bool = true
func _process(delta: float) -> void:
	var StartAt:Vector2 = global_position
	var EndAt:Vector2 = %LegEnd.global_position
	if (%LegEnd.global_position - %Target.global_position).length() > STEP_LENGTH and !_moving and canMove: # 重置落腳點
		_moving = true
		var tween = create_tween()
		tween.tween_property(%LegEnd, "global_position", %Target.global_position, 0.01)
		tween.tween_interval(0.01)
		tween.tween_property(self, "_moving", false, 0.0)
		#%LegEnd.global_position = %Target.global_position
	for i in range(3):
		FABRIK_F(StartAt, EndAt)
		FABRIK_I(StartAt, EndAt)
		FABRIK_F(StartAt, EndAt)
	
func FABRIK_F(start:Vector2, end:Vector2):  # 正向
	var arr:PackedVector2Array = %Line2D.points
	arr[0] = start
	for i in range(1, arr.size()):
		#if (arr[i] - arr[i-1]).length() > LENGTH:
		arr[i] = (arr[i] - arr[i-1]).normalized() * LENGTH + arr[i-1]
	%Line2D.points = arr

func FABRIK_I(start:Vector2, end:Vector2):  # 反向
	var arr:PackedVector2Array = %Line2D.points
	arr[-1] = end
	for i in range(arr.size()-2, -1, -1): # 反向
			#if (arr[i] - arr[i+1]).length() > LENGTH:
			arr[i] = (arr[i] - arr[i+1]).normalized() * LENGTH + arr[i+1]
	%Line2D.points = arr

func setColor(color:Color):
	%Line2D.default_color = color
