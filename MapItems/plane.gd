extends Sprite2D
#calss_name Plane

var game_pos:Vector2i
var edge_game_pos:Dictionary
		
func set_edge_game_pos(up, left, down, right):
	edge_game_pos = {
		"UP": up,
		"LEFT": left,
		"DOWN": down,
		"RIGHT": right,
	}
func get_edge_game_pos(s):
	return edge_game_pos[s]

func initialize(game_pos:Vector2i, pos, spacing):
	var texture_size:Vector2i = texture.get_size()
	
	self.game_pos = game_pos
	
	self.name = "plane_{x}_{y}".format({
		"x":game_pos.x, "y":game_pos.y})
	self.position = pos + spacing / 2
	self.region_enabled = true
	self.region_rect = Rect2((texture_size - spacing) / 2, spacing)
	
	var up = Vector3i(game_pos.x, game_pos.y, 1)
	var left = Vector3i(game_pos.x, game_pos.y, 0)
	var down = Vector3i(game_pos.x, game_pos.y + 1, 1)
	var right = Vector3i(game_pos.x + 1, game_pos.y, 0)
	set_edge_game_pos(up, left, down, right)
	
	printt(name, game_pos, position)
