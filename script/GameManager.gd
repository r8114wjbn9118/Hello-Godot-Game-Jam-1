extends Node



func _ready() -> void:
	_load_save_data()


var LEVEL:Array = [null, ## 0留空
	"res://scene/level/Level_1.tscn",
	"res://scene/level/Level_2.tscn",
	"res://scene/level/Level_3.tscn",
	"res://scene/level/Level_4.tscn",
	"res://scene/level/Level_5.tscn",
	"res://scene/level/Level_6.tscn",
	"res://scene/level/Level_7.tscn",
	"res://scene/level/Level_8.tscn",
	"res://scene/level/Level_9.tscn",
	"res://scene/level/Level_10.tscn"
]
func get_available_level()-> int:
	return LEVEL.size() - 1

func goto_level(target:int):
	if target >= LEVEL.size():
		printerr('GameManager.goto_level({0}): 無效目標'.format([target]))
		return
		
	var path = LEVEL[target]
	if path:
		get_tree().change_scene_to_file(path)
	else:
		printerr('GameManager.goto_level({0}): 無效目標'.format([target]))


var SCENE:Dictionary = {
	"title": "res://scene/title.tscn",
	"select": "res://scene/selectLevel.tscn",
	"start": "res://scene/start.tscn",
	"end": "res://scene/end.tscn",
	"creddit": "res://scene/Credit.tscn"
}

func goto_scene(target:String):
	var path = SCENE.get(target, null)
	if path:
		printt("GOTO", target, path)
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

signal change_player_action
signal check_level_finish

var player_action:ACTION = ACTION.PROHIBIT:
	set(value):
		if is_moving():
			check_level_finish.emit()
		change_player_action.emit(player_action, value)
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
func reset_save_data():
	_save_data = SaveData.new()
	_save_data.SaveSelf()
	print_rich("[color=green]SaveData reset ![/color]")

func _load_save_data(): # call by _ready
	_save_data = SaveData.LoadSelf()
		
	

func GetFinishedLevel()-> Array[int]:
	return _save_data.GetFinishedLevels()

func finish_level(n):
	print_rich("[color=green]Level {0} Clear ![/color]".format([n]))
	if not n in _save_data.GetFinishedLevels():
		_save_data.AddFinishedLevel(n)
		_save_data.SaveSelf()
		if is_finish_game():
			goto_scene("end")
		else:
			goto_level(n + 1)
	else:
		goto_scene("select")

func is_finish_game():
	return _save_data.GetFinishedLevels().size() == LEVEL.size()

#endregion

#region 新建程式碼區域

func is_finished_anim(anim_name:String):
	return _save_data.AnimIsFinished(anim_name)

func finish_anim(anim_name:String):
	print(is_finished_anim(anim_name))
	if not is_finished_anim(anim_name):
		_save_data.AddFinishedAnim(anim_name)
	print(is_finished_anim(anim_name))

#endregion

#region 背景

var title_background = [
	"res://image/過關畫面/影格1.png",
	"res://image/過關畫面/影格3.png",
]

func get_title_background():
	var target = 1 if is_finish_game() else 0
	var path = title_background[target]
	return load(path)

#endregion

#region 前景

enum FG_TYPE {
	MONOCHRMOE,
	SPRING,
	SUMMER,
	FALL,
	WINTER
}
var forefround_list = [
	"res://image/觀察箱底圖素材/黑白.png",
	"res://image/觀察箱底圖素材/春.png",
	"res://image/觀察箱底圖素材/夏.png",
	"res://image/觀察箱底圖素材/秋.png",
	"res://image/觀察箱底圖素材/冬.png",
]

func get_fg_img(target:FG_TYPE):
	if target == null:
		return null
	if target >= forefround_list.size():
		return null
	
	var path = forefround_list[target]
	return load(path)

#endregion
