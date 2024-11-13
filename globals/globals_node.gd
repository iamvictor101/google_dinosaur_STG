extends Node
#用于控制场景转换
@export var speed := 1.0
@export var unobstructed := false
@export var OP := false
@export var weightlessness := false
@export var turtle_f := 0.0
@onready var player_stats: Stats = $Player_Stats
@onready var mouse_cursor: CanvasLayer = $mouse_cursor
@onready var save_operate: SaveOperate = $SaveOperate
var point: int = 0
var max_point: int
var in_ui := true#判断是否在ui
func _ready() -> void:
	print("感谢你游玩我的游戏")
func _process(_delta: float) -> void:
	#
	if in_ui == false:
		mouse_cursor.animated_sprite_2d.play("aim")
	elif in_ui == true:
		mouse_cursor.animated_sprite_2d.play("mouse")
	#鼠标状态的切换
