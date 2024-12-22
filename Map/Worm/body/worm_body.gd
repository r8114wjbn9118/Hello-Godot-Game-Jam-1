@tool
class_name Worm extends Node2D

signal move_finish_signal()

@export var move_time:float = 0.5

var color_list = [
	{
		"head_img": "res://Map/Worm/image/blue_head.png",
		"body_img": "res://Map/Worm/image/blue_body.png",
		"leg_color": Color("cfdeff"),
	},
	{
		"head_img": "res://Map/Worm/image/pink_head.png",
		"body_img": "res://Map/Worm/image/pink_body.png",
		"leg_color": Color("d38fb2")
	},
]
enum COLOR_TYPE {BLUE = 0, PINK = 1}
@export var color:COLOR_TYPE = COLOR_TYPE.PINK:
	set(value):
		color = value
		var args = color_list[value]
		head_img = args.head_img
		body_img = args.body_img
		leg_color = args.leg_color


var head_img:
	set(value):
		head_img = value
		if value and head:
			var img = load(value)
			head.texture = img
var body_img:
	set(value):
		body_img = value
		if value and _bodyLine:
			var img = load(value)
			_bodyLine.body_img = img
var leg_color:
	set(value):
		leg_color = value
		if value is Color:
			if _bodyLine: _bodyLine.leg_color = value

@onready var point_manager = %Point

var max_move_distance:int = 8
var game_pos:Vector2i

#var action_distance:int = 1 # 行動距離

func setScale(new):
	scale = new
func getScale():
	return get_parent().scale
	

func init():
	_pathLine.init(self, point_manager)
	_bodyLine.init(self, point_manager)
	color = color
	
func init_pos():
	game_pos = point_manager.get_tile_game_pos(global_position)
	global_position = point_manager.get_tile_position(game_pos)
	
# 編輯地圖時隱藏身體
func _ready() -> void:
	%PathLine.visible = not Engine.is_editor_hint()
	%Body.visible = not Engine.is_editor_hint()


#region by DF
@onready var _pathLine = %Path
@onready var _bodyLine = %Body
@onready var head = %Head

func set_pos(game_pos): # NOTE 由UNDO調用
	rotation = Vector2(self.game_pos - game_pos).angle() - PI / 2
	self.game_pos = game_pos
	global_position = point_manager.get_tile_position(game_pos)

func _make_tween(target_pos):
	var tween = get_tree().create_tween()
	tween.tween_method(_tween_move, global_position, target_pos, move_time) \
		.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	tween.tween_callback(move_finish)

func _tween_move(new_pos): # TEST 替代move
	global_position = new_pos
	_pathLine.move()
	_bodyLine.move()


func _move(): # NOTE move  (不應該被直接調用)
	pass
func _unmove(PathPoints, BodyPoints): # NOTE move 的反向操作 (不應該被直接調用)
	_pathLine.points = PathPoints
	_bodyLine.points = BodyPoints
	_pathLine.move()
	_bodyLine.move()


@onready var _undoRedo:UndoRedo = UndoRedo.new()
func Do(): # NOTE 由WormManager調用
	_undoRedo.create_action("nothing")
	
	_undoRedo.add_do_method(_move)
	_undoRedo.add_do_method(_bodyLine.Do)
	
	_undoRedo.add_undo_method(_unmove.bind(_pathLine.points, _bodyLine.points))
	_undoRedo.add_undo_method(_bodyLine.Undo)
	_undoRedo.commit_action()
func Undo():
	if _undoRedo.has_undo():
		_undoRedo.undo()
#endregion

func start_move(target_game_pos):
	var target_pos = point_manager.get_tile_position(target_game_pos)
	rotation = Vector2(game_pos - target_game_pos).angle() + PI / 2
	_make_tween(target_pos) # TEST
	game_pos = target_game_pos

func move_finish():
	move_finish_signal.emit()
