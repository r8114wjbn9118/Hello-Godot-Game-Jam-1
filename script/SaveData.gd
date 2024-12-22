class_name SaveData extends Resource

#region Level

@export var finished_level:Array[int] = [0,
#1,2,3,4,5,6,7,8
] #NOTE 0有特殊意義 關聯LevelSelect
@export var game_finish:bool = false: # NOTE 通關
	set(value):
		game_finish = value
		SaveSelf()

func AddFinishedLevel(level:int) -> void:
	finished_level.append(level)
	SaveSelf()

func GetFinishedLevels()-> Array[int]: return finished_level

func LevelIsFinished(level:int):
	return level in finished_level

#endregion

#region Anim

@export var finished_anim:Array[String] = []

func AddFinishedAnim(anim_name:String):
	finished_anim.append(anim_name)
	SaveSelf()
	
func GetFinishedAnim()-> Array[String]: return finished_anim

func AnimIsFinished(anim_name:String):
	return anim_name in finished_anim

#endregion

#region SaveLoad

const SAVE_PATH = "user://save.tres"

func _init() -> void:
	if not ResourceLoader.exists(SAVE_PATH):
		SaveSelf()
	

func SaveSelf()-> void:
	printt("Save", error_string(ResourceSaver.save(self, SAVE_PATH)))
	
static func LoadSelf()-> SaveData:
	return SaveData.new()
	var file = ResourceLoader.load(SAVE_PATH, "SaveData")
	if !file: # 加載失敗返回新實例
		print_rich("[color=red]存檔加載失敗返回新實例[/color]")
		return SaveData.new()
	
	print_rich("[color=green]存檔加載成功[/color] data:{")
	print_rich(file.finished_level)
	print_rich(file.finished_anim)
	print("}")
	return file
	
#endregion
	







#
