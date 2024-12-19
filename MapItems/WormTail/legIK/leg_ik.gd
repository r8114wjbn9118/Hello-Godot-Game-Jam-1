@tool
extends Node2D


const LENGTH = 20.0
const STEP_LENGTH = 20.0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var StartAt:Vector2 = global_position
	var EndAt:Vector2 = %LegEnd.global_position
	if (%LegEnd.global_position - %Target.global_position).length() > STEP_LENGTH: # 重置落腳點
		%LegEnd.global_position = %Target.global_position
	for i in range(10):
		FABRIK_F(StartAt, EndAt)
		FABRIK_I(StartAt, EndAt)
		FABRIK_F(StartAt, EndAt)
	
func FABRIK_F(start:Vector2, end:Vector2):  # 正向
	var arr:PackedVector2Array = %Line2D.points
	arr[0] = start
	for i in range(1, arr.size()):
		if (arr[i] - arr[i-1]).length() > LENGTH:
			arr[i] = (arr[i] - arr[i-1]).normalized() * LENGTH + arr[i-1]
	arr[-1] = end
	%Line2D.points = arr
func FABRIK_I(start:Vector2, end:Vector2):  # 反向
	var arr:PackedVector2Array = %Line2D.points
	for i in range(arr.size()-2, -1, -1): # 反向
			if (arr[i] - arr[i+1]).length() > LENGTH:
				arr[i] = (arr[i] - arr[i+1]).normalized() * LENGTH + arr[i+1]
	%Line2D.points = arr
