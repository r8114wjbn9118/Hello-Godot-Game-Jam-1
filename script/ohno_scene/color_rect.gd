extends ColorRect

@export var curve:Curve

var time = 0.0
func _process(delta: float) -> void:
	time += delta
	color.a = curve.sample_baked(time/5.0)
