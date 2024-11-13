class_name SaveOperate
extends Node
func save_game() -> void:#参数是要保存玩家的场景
#存档点的保存
	GlobalsNode.player_stats.health = GlobalsNode.player_stats.max_health#回满血量
	var file:SaveResource = SaveResource.new()#新建一个存档变量
	file.max_point = GlobalsNode.max_point
	ResourceSaver.save(file,"user://presave.tres")#创建或覆盖存档
func load_game() -> void:
#加载存档
	var file:SaveResource = SafeResourceLoader.load("user://presave.tres") as SaveResource
	#as SaveResourse是用来让下面的代码写的时候能有自动填充
	if file == null:
		print("你的存档不安全")
		return
	GlobalsNode.max_point = file.max_point
