class_name SaveData extends Resource

#region Level
@export var finished_level:Array[int] = []

func AddFinishedLevel(level:int) -> void:
	pass

func GetFinishedLevels()-> Array[int]: return finished_level
#endregion


#region SaveLoad
const SAVE_PATH = "user://save.dat"

func SaveSelf()-> void:
	ResourceSaver.save(self, SAVE_PATH)

static func LoadSelf()-> SaveData:
	var file = ResourceLoader.load(SAVE_PATH, "SaveData")
	if !file: # 加載失敗返回新實例
		print_rich("[color=red]加載失敗返回新實例[/color]")
		file = SaveData.new()
	else:
		print_rich("[color=red]加載成功[/color]")
	return file
#endregion
	







#
