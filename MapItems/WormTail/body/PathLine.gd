@tool
extends LineManager
class_name PathLine

func init(head, point_manager, color):
	max_distance = head.max_move_distance
	
	super.init(head, point_manager, color)

func _ready() -> void:
	line = %PathLine
