extends TileMapLayer
class_name TileManager

var check_update_list = []

func need_update_child() -> bool:
	var new_list = get_used_cells()
	if new_list.size() == check_update_list.size():
		for i in check_update_list.size():
			if new_list[i] != check_update_list[i]:
				break
		return false
	check_update_list = new_list
	return true



func get_tile_game_pos(pos):
	return local_to_map(pos / get_parent().scale - position)

func get_tile_position(pos):
	return map_to_local(pos) * get_parent().scale + position
	
func get_tile_center_pos(pos):
	return get_tile_position(get_tile_game_pos(Vector2(pos)))
