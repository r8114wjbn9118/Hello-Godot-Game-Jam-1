@tool
extends LineManager
class_name PathLine

var path_color:
	set(value):
		path_color = value
		if value is Color:
			line.gradient.colors[0] = value
func init(worm, point_manager):
	max_distance = worm.max_move_distance
	
	super.init(worm, point_manager)

func _ready() -> void:
	line = %PathLine
