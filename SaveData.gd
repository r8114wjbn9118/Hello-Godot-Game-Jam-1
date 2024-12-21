class_name SaveData extends Resource

#region Level
@export var finished_level:Array[int] = [0] #NOTE 0有特殊意義 關聯LevelSelect

func AddFinishedLevel(level:int) -> void:
	finished_level.append(level)

func GetFinishedLevels()-> Array[int]: return finished_level
#endregion


#region SaveLoad
const SAVE_PATH = "user://save.tres"

func SaveSelf()-> void:
	print(ResourceSaver.save(self, SAVE_PATH))
	

static func LoadSelf()-> SaveData:
	var file = ResourceLoader.load(SAVE_PATH, "SaveData")
	if !file: # 加載失敗返回新實例
		print_rich("[color=red]存檔加載失敗返回新實例[/color]")
		file = SaveData.new()
	else:
		print_rich("[color=green]存檔加載成功[/color] data:{")
		print_rich(file.finished_level)
		print("}")
	return file
#endregion
	







#
