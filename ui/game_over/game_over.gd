extends ParallaxBackground
@onready var save_operate: SaveOperate = GlobalsNode.save_operate
@onready var label: Label = $Control/Label
@onready var out: Button = $Control/out
func _ready() -> void:
	GlobalsNode.in_ui = true#改变鼠标样子
	get_tree().paused = true
func _on_out_pressed() -> void:
	get_tree().paused = false
	save_operate.save_game()
	var tree := get_tree()
	tree.change_scene_to_file("res://scenes/main/main.tscn")
	queue_free()
