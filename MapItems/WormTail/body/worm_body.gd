@tool
class_name Worm extends Node2D

signal change_state(target, old_state, new_state)
signal move_finish_signal()

var color_list = [
	{ ## NOTE 需要調整
		"head_img": "res://image/洞螈圖示（粉／藍）/藍藍洞螈.png",
		"path_color": Color("blue"),
		"body_color": Color("blue"),
		"leg_color": Color("blue"),
	},
	{
		"head_img": "res://image/洞螈圖示（粉／藍）/粉紅洞螈.png",
		"path_color": Color("bf7441"),
		"body_color": Color("e1e1e1"),
		"leg_color": Color("d38fb2")
	},
]
enum COLOR_TYPE {BLUE = 0, PINK = 1}
@export var color:COLOR_TYPE = COLOR_TYPE.PINK:
	set(value):
		printt(self, color, value)
		color = value
		var args = color_list[value]
		head_img = args.head_img
		path_color = args.path_color
		body_color = args.body_color
		leg_color = args.leg_color

var head_img:
	set(value):
		head_img = value
		var head = %Head
		if value and head:
			var img = load(value)
			head.texture = img
var path_color:
	set(value):
		path_color = value
		if value is Color:
			if _pathLine: _pathLine.color = value
var body_color:
	set(value):
		body_color = value
		if value is Color:
			if _bodyLine: _bodyLine.color = value
var leg_color:
	set(value):
		leg_color = value
		if value is Color:
			if _bodyLine: _bodyLine.leg_color = value

@onready var point_manager = %Point

var state:GameManager.ACTION :
	set(value):
		change_state.emit(self, state, value)
		state = value

var move_speed:float = 200
var max_move_distance:int = 8

var game_pos:Vector2i
var target_game_pos
var target_pos

#var action_distance:int = 1 # 行動距離

func init():
	init_pos()
	_pathLine.init(self, point_manager, path_color)
	_bodyLine.init(self, point_manager, body_color)
	color = color
	
func init_pos():
	game_pos = point_manager.get_point_game_pos(position)
	position = point_manager.get_point_position(game_pos)

func _physics_process(delta: float):
	if state == GameManager.ACTION.MOVE:
		if not move(delta):
			move_finish()


#region by DF
@onready var _pathLine:PathLine = %Path
@onready var _bodyLine:BodyLine = %Body
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_pathLine.visible = not Engine.is_editor_hint()
	_bodyLine.visible = not Engine.is_editor_hint()

func set_pos(game_pos): # NOTE 由UNDO調用
	rotation = Vector2(self.game_pos - game_pos).angle() - PI / 2
	self.game_pos = game_pos
	position = point_manager.get_point_position(game_pos)

func move(delta):
	var distance = move_speed * delta

	position += position.direction_to(target_pos) * distance
	_pathLine.move(position)
	_bodyLine.move(position)
	
	return not reach_destination(position, target_pos, distance)

func _move(): # NOTE move  (不應該被直接調用)
	pass
func _unmove(PathPoints, BodyPoints): # NOTE move 的反向操作 (不應該被直接調用)
	_pathLine.points = PathPoints
	_bodyLine.points = BodyPoints
	_pathLine.move(position)
	_bodyLine.move(position)


@onready var _undoRedo:UndoRedo = UndoRedo.new()
func Do(): # NOTE 由WormManager調用
	_undoRedo.create_action("nothing")
	_undoRedo.add_undo_method(_move)
	#print_tree_pretty()
	_undoRedo.add_undo_method(_unmove.bind(_pathLine.points, _bodyLine.points))
	_undoRedo.commit_action()
func Undo():
	if _undoRedo.has_undo():
		_undoRedo.undo()
#endregion

func reach_destination(a, b, distance):
	if a.distance_squared_to(b) < distance:
		position = b
		return true
	return false



func start_move(target_game_pos):
	printt(name + " Start Move", target_game_pos)
	self.target_game_pos = target_game_pos
	self.target_pos = point_manager.get_point_position(target_game_pos)
	rotation = Vector2(game_pos - target_game_pos).angle() + PI / 2
	state = GameManager.ACTION.MOVE

func move_finish():
	game_pos = target_game_pos
	target_game_pos = null
	state = GameManager.ACTION.WAIT
	move_finish_signal.emit()
