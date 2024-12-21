class_name SaveData extends Resource

#region Level

@export var finished_level:Array[int] = [0] #NOTE 0有特殊意義 關聯LevelSelect

func AddFinishedLevel(level:int) -> void:
	finished_level.append(level)

func GetFinishedLevels()-> Array[int]: return finished_level

func LevelIsFinished(level:int):
	if level == 0:
		return false
	return level in finished_level

#endregion

#region Anim

var finished_anim = []

func AddFinishedAnim(anim_name:String):
	finished_anim.append(anim_name)
	
func GetFinishedAnim()-> Array[int]: return finished_anim

func AnimIsFinished(anim_name:String):
	return anim_name in finished_anim

#endregion

#region SaveLoad
const SAVE_PATH = "user://save.tres"

func _init() -> void:
	if not ResourceLoader.exists(SAVE_PATH):
		SaveSelf()
	

func SaveSelf()-> void:
	print(ResourceSaver.save(self, SAVE_PATH))
	

static func LoadSelf()-> SaveData:
	var file = ResourceLoader.load(SAVE_PATH, "SaveData")
	if !file: # 加載失敗返回新實例
		print_rich("[color=red]存檔加載失敗返回新實例[/color]")
		return SaveData.new()
	
	print_rich("[color=green]存檔加載成功[/color] data:{")
	print_rich(file.finished_level)
	print("}")
	return file
#endregion
	







#
