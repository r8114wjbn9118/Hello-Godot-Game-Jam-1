extends Line2D
#class_name Edge

var game_pos:Vector2i
var point_game_pos:Array[Vector2i]
var direction:Vector2i

func initialize(game_pos,point_pos_list,direction = null):
	self.game_pos = game_pos
	if direction:
		self.direction = direction
	else:
		self.direction = point_pos_list[0].direction_to(point_pos_list[-1])
	self.point_game_pos = [game_pos, game_pos + direction]
	
	self.name = "edge_{d}_{x}_{y}".format({
		"d":direction.x, "x":game_pos.x, "y":game_pos.y})
	self.points = point_pos_list
	
	printt(name, game_pos, point_game_pos, direction)
