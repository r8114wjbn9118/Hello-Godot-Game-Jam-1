extends Sprite2D

var game_pos:Vector2i
var plane:Node2D

func initialize(game_pos:Vector2i, plane_node):
	self.game_pos = game_pos
	self.plane = plane_node
	
	self.name = "eye"
	self.position = self.plane.position
