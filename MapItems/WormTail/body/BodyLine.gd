@tool
extends LineManager
class_name BodyLine

@onready var Path = $Path2D/PathFollow2D
@onready var FR = %LegIk_FR
@onready var FL = %LegIk_FL
@onready var BR = %LegIk_BR
@onready var BL = %LegIk_BL

var body_img:
	set(value): line.texture = value
	get: return line.texture
		

var leg_color:
	set(value):
		leg_color = value
		if value is Color:
			if FR: FR.line.default_color = value
			if FL: FL.line.default_color = value
			if BR: BR.line.default_color = value
			if BL: BL.line.default_color = value

func _ready() -> void:
	## 身體長度
	max_distance = 1
	line = %BodyLine



## 頭部移動時連帶執行
func move() -> void:
	super.move()
	
	%Body.global_position = Vector2.ZERO
	%Body.global_rotation = 0.0
	
	var curve:Curve2D = $Path2D.curve
	curve.clear_points()
	for i in points:
		curve.add_point(i)
	const FRONT_POS = 0.2
	const BACK_POS = 0.6

	var Path_rotate
	
	Path.progress_ratio = FRONT_POS
	Path_rotate = Path.global_rotation
	FR.global_position = %RMarker2D.global_position
	FR.global_rotation = Path_rotate + PI/2
	FR.start_move()
	FL.global_position = %LMarker2D.global_position
	FL.global_rotation = Path_rotate - PI/2
	FL.start_move()
	
	Path.progress_ratio = BACK_POS
	Path_rotate = Path.global_rotation
	BR.global_position = %RMarker2D.global_position
	BR.global_rotation = Path_rotate + PI/2
	BR.start_move()
	BL.global_position = %LMarker2D.global_position
	BL.global_rotation = Path_rotate - PI/2
	BL.start_move()
