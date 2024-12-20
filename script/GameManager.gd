extends Node

var LEVEL:Array = [null, ## 0留空
	"res://scene/level/1.tscn",
]

var SCENE:Dictionary = {
	"title": "res://scene/title.tscn",
	"select": "res://scene/selectLevel.tscn",
	"start": "res://scene/start.tscn",
	"end": "res://scene/end.tscn"
}

#region 玩家行動

enum ACTION {
	PROHIBIT,
	WAIT,
	MOVE,
	BACK
}

signal check_level_finish()

var player_action:ACTION = ACTION.PROHIBIT:
	set(value):
		if is_moving():
			check_level_finish.emit()
		player_action = value
			
func is_waiting():
	return player_action == ACTION.WAIT

func is_moving():
	return player_action == ACTION.MOVE

func is_backing():
	return player_action == ACTION.BACK
	
func in_action():
	return is_moving() or is_backing()

func start_move(type:int = 1):
	if type > 0:
		player_action = ACTION.MOVE
	elif type < 0:
		player_action = ACTION.BACK
	return player_action
	
func move_finish():
	player_action = ACTION.WAIT
	
func prohibit_action(b:bool):
	if in_action():
		return -1
	player_action = ACTION.PROHIBIT if b else ACTION.WAIT
	return player_action
	
#endregion

#region 關卡完成檢測

var finished_level:Array[int] = [0]

func finish_level(n):
	if not n in finished_level:
		finished_level.append(n)
		if is_finish_game():
			goto_scene("end")

func is_finish_game():
	return finished_level.size() == LEVEL.size()

#endregion

func goto_scene(target:String):
	var path = SCENE.get(target, null)
	if path:
		get_tree().change_scene_to_file(path)
	else:
		printerr('GameManager.goto_scene("{0}"): 無效目標'.format([target]))
