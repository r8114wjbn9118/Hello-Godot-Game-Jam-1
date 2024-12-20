@tool
extends LineManager
class_name PathLine

func init(worm, point_manager):
	max_distance = worm.max_move_distance
	
	super.init(worm, point_manager)

func _ready() -> void:
	line = %PathLine
