extends Node

func _ready() -> void:
	_load_save_data()
	print(OS.get_locale())

var LEVEL:Array = [null, ## 0留空
	"res://scene/level/Level_1.tscn",
	"res://scene/level/Level_2.tscn",
	"res://scene/level/Level_3.tscn"
]

func goto_level(target:int):
	var path = LEVEL[target]
	if path:
		get_tree().change_scene_to_file(path)
	else:
		printerr('GameManager.goto_level({0}): 無效目標'.format([target]))

var SCENE:Dictionary = {
	"title": "res://scene/title.tscn",
	"select": "res://scene/selectLevel.tscn",
	"start": "res://scene/start.tscn",
	"end": "res://scene/end.tscn"
}

func goto_scene(target:String):
	var path = SCENE.get(target, null)
	if path:
		get_tree().change_scene_to_file(path)
	else:
		printerr('GameManager.goto_scene("{0}"): 無效目標'.format([target]))

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


var _save_data:SaveData # 必須在開始時分配實例
func _load_save_data(): # call by _ready
	_save_data = SaveData.LoadSelf()

func GetFinishedLevel()-> Array[int]:
	return _save_data.GetFinishedLevels()

func finish_level(n):
	print("from GameManager: finish {0}".format([n]))
	print("change level: {0}".format([not n in _save_data.GetFinishedLevels()]))
	if not n in _save_data.GetFinishedLevels():
		_save_data.AddFinishedLevel(n)
		_save_data.SaveSelf()
		if is_finish_game():
			goto_scene("end")
		else:
			goto_level(n+1)

func is_finish_game():
	return _save_data.GetFinishedLevels().size() == LEVEL.size()

#endregion
