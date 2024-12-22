@tool
extends TileManager
class_name EyeManager

@export var eye:PackedScene

enum TYPE {
	NULL,
	SPACE,
	EYE
}
var coords_type:Dictionary = {
	Vector2i(0,0): TYPE.SPACE,
	Vector2i(0,3): TYPE.EYE
}

var eye_game_pos_list:Array = []

func _ready() -> void:
	for child in get_children():
		child.queue_free()


func need_update_child():
	if super.need_update_child():
		return true

	var new_list = get_game_pos_list()
	if new_list.size() == eye_game_pos_list.size():
		for i in eye_game_pos_list.size():
			if new_list[i] != eye_game_pos_list[i]:
				break
		return false
	eye_game_pos_list = new_list
	return true

func update_child(point_list:Array[Vector2i]):
	eye_game_pos_list = get_game_pos_list()

	clear()

	var generated_eye_game_pos = []
	for child in get_children():
		if child.game_pos in eye_game_pos_list:
			generated_eye_game_pos.append(child.game_pos)
		else:
			child.queue_free()
	for game_pos in eye_game_pos_list:
		create_eye_cell(game_pos)

		if game_pos in generated_eye_game_pos:
			continue

		var node = eye.instantiate()
		node.init(self, game_pos)
		add_child(node)


	for point in point_list:
		if point in eye_game_pos_list:
			continue

		if not (point + Vector2i.ONE) in point_list:
			continue
		if not (point + Vector2i.RIGHT) in point_list:
			continue
		if not (point + Vector2i.DOWN) in point_list:
			continue

		create_cell(point)


func create_cell(vec:Vector2i):
	set_cell(vec, 1, Vector2i(0, 0))

func create_eye_cell(vec:Vector2i):
	set_cell(vec, 1, Vector2i(0, 3))


func get_game_pos_list():
	var list:Array[Vector2i] = []
	var used_cell_list:Array[Vector2i] = get_used_cells()
	for pos in used_cell_list:
		var pos_type:TYPE = coords_type.get(get_cell_atlas_coords(pos))
		if pos_type == TYPE.EYE:
			list.append(pos)
	return list
