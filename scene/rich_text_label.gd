extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
# This assumes RichTextLabel's `meta_clicked` signal was connected to
# the function below using the signal connection dialog.


func _on_meta_clicked(meta: Variant) -> void:
	OS.shell_open(str(meta))
