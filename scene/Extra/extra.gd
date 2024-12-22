class_name Extra extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%AnimationPlayer.play("in")
	#for i in range(60):
		#var node := preload("res://Map/Eye/EyeAnim.tscn").instantiate()
		#node.trackMode  = true
		#node.position = \
			#Vector2(randi_range(0, get_window().size.x), randi_range(0, get_window().size.y))
		#%Control.add_child(node)





func _process(delta: float) -> void:
	pass
