class_name Cutscene extends Node
signal start
signal end
func _ready() -> void:
	start.connect(_start)
func _start():
	pass
func _end():
	print("Cutscene end")
	end.emit()
