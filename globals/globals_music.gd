extends Node
#用于控制ui和环境音
enum Bus { Master, SFX, BGM, AMBIENCE }
#enum类与int类互通，目的是能将总线传入get_volume()和set_volume()这两个函数中
@onready var sudden_battle: AudioStreamPlayer = $sudden_battle
func get_volume(bus_index: int) -> float:
#获取可以作为参数的音量值
	var db := AudioServer.get_bus_volume_db(bus_index)#获取索引为bus_index的总线的音量
	return db_to_linear(db)#分贝转换为线性能量
func set_volume(bus_index: int, v: float) -> void:
#设置音量
	var db := linear_to_db(v)#线性能量转换为分贝
	AudioServer.set_bus_volume_db(bus_index, db)#将索引为bus_index的总线的音量设为db
func switch_ambienc(_name: String) -> void:
	pass
	#if ambience.get_node(_name).playing == true:
				#return
	#for i in ambience.get_child_count(true):
		#if ambience.get_child(i).name == _name:
			#ambience.get_child(i).playing = true
		#else:
			#ambience.get_child(i).playing = false
