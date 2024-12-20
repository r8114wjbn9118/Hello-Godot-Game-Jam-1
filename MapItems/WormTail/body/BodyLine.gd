extends LineManager
class_name BodyLine

@onready var Path = $Path2D/PathFollow2D
@onready var FR = %LegIk_FR
@onready var FL = %LegIk_FL
@onready var BR = %LegIk_BR
@onready var BL = %LegIk_BL

func _ready() -> void:
	## 身體長度
	max_distance = 2
	line = %BodyLine



## 頭部移動時連帶執行
func move(pos) -> void:
	super.move(pos)
	
	var curve:Curve2D = $Path2D.curve
	curve.clear_points()
	for i in line.points.duplicate():
		curve.add_point(i)
	const FRONT_POS = 0.2
	const BACK_POS = 0.8
	
	var Path_pos
	var Path_rotate
	
	Path.progress_ratio = FRONT_POS
	Path_pos = Path.global_position
	Path_rotate = Path.global_rotation
	printt(Path.progress_ratio, Path_pos, Path_rotate)
	FR.position = Path_pos
	FR.rotation = Path_rotate + PI/2
	FL.position = Path_pos
	FL.rotation = Path_rotate - PI/2
	
	Path.progress_ratio = BACK_POS
	Path_pos = Path.global_position
	Path_rotate = Path.global_rotation
	printt(Path.progress_ratio, Path_pos, Path_rotate)
	BR.position = Path_pos
	BR.rotation = Path_rotate + PI/2
	BL.position = Path_pos
	BL.rotation = Path_rotate - PI/2
