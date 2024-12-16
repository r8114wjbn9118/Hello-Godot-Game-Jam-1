extends Sprite2D
#class_name Point

var game_pos:Vector2i

func initialize(game_pos:Vector2i, position):
	self.game_pos = game_pos
	
	self.name = "point_{x}_{y}".format({
		"x":game_pos.x, "y":game_pos.y})
	self.position = position
	
	printt(name, game_pos, position)
