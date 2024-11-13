extends Node2D
@onready var save_operate: SaveOperate = GlobalsNode.save_operate
@onready var tile_map_layer: TileMapLayer = $TileMapLayer
@onready var camera: TileMapLayer = $camera
@onready var _floor: ParallaxLayer = $ParallaxBackground/floor
@onready var control: Control = $CanvasLayer/Control
@onready var accelerate: CheckBox = $CanvasLayer/Control/HBoxContainer/VBoxContainer/Accelerate
@onready var unobstructed: CheckBox = $CanvasLayer/Control/HBoxContainer/VBoxContainer/Unobstructed
@onready var invincible: CheckBox = $CanvasLayer/Control/HBoxContainer/VBoxContainer/Invincible
@onready var out_game: Button = $CanvasLayer/Control/HBoxContainer/VBoxContainer/Out_game
@onready var esc: Control = $CanvasLayer/Control2/esc
@onready var go_on: Button = $CanvasLayer/Control2/esc/HBoxContainer/Go_on
@onready var out: Button = $CanvasLayer/Control2/esc/HBoxContainer/Out
@onready var hi: Label = $CanvasLayer/Control2/HI
@onready var player: Player = $Player
@onready var camera_2d: Camera2D = $Player/Camera2D
@onready var enemy_point: Marker2D = $enemy_point
@export var begin := false
var in_esc := false
var end := false
var point := 0
var smileysed := false
var bgm_seek: float
var bgm := 0
var player_position: Vector2
func _ready() -> void:
	var used := camera.get_used_rect()
	var camera_size := camera.tile_set.tile_size
	camera_2d.limit_top = used.position.y * camera_size.y + 16
	camera_2d.limit_bottom = used.end.y * camera_size.y - 20
	camera_2d.limit_left = used.position.x * camera_size.x + 16
	camera_2d.limit_right = used.end.x * camera_size.x - 16
	camera_2d.reset_smoothing()
	#相机逻辑
	if GlobalsNode.speed == 2:
		accelerate.button_pressed = true
	if GlobalsNode.unobstructed:
		unobstructed.button_pressed = true
	if GlobalsNode.OP:
		invincible.button_pressed = true
	GlobalsNode.weightlessness = false
	GlobalsState.form = GlobalsState.FORM.RUN
	point = 0
	GlobalsSignal.connect("player_position_update", Callable(self, "player_position_record"))
	_cloud_born()
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("begin") and not begin:
		_begin()
	if event.is_action_pressed("esc") and begin:
		if in_esc:
			_exit_esc()
		else :
			_enter_esc()
func _process(delta: float) -> void:
	if begin:
		_floor.motion_offset.x -= delta * 100 * GlobalsNode.speed
func _camera_shake(_time: float, _num: int, _range: float) -> void:
	#参数分别为：总时长，次数，幅度
	var _fv: float = _time / _num#频率
	var i = 0
	while i < _num:
		var _add := Vector2(randf_range(-_range, _range), randf_range(-_range, _range)) 
		camera_2d.offset += _add
		await get_tree().create_timer(_fv).timeout
		camera_2d.offset -= _add
		i += 1
func player_position_record(pos):
	player_position = pos
func _begin() -> void:
	begin = true
	control.queue_free()
	player.begin = true
	hi.show()
	_cactus_born()
	_bird_born()
	_meteorite_born()
	_add_point()
func _enter_esc() -> void:
	in_esc = true
	if GlobalsMusic.sudden_battle.playing == true:
		bgm_seek = GlobalsMusic.sudden_battle.get_playback_position()
		GlobalsMusic.sudden_battle.stop()
		bgm = 1
	GlobalsNode.in_ui = true
	get_tree().paused = true
	esc.show()
	go_on.disabled = false
	out.disabled = false
func _exit_esc() -> void:
	in_esc = false
	if bgm == 1:
		GlobalsMusic.sudden_battle.play(bgm_seek)
	GlobalsNode.in_ui = false
	get_tree().paused = false
	esc.hide()
	go_on.disabled = true
	out.disabled = true
func _cactus_born() -> void:
	if GlobalsNode.unobstructed:
		return
	#仙人掌生成函数
	while begin:
		if not (in_esc or end):
			var okey := randi_range(0, 3)
			if okey > 0:
				for i in okey:
					var cactus := preload("res://enemy/cactus/cactus.tscn").instantiate()
					add_child(cactus)
					cactus.global_position = enemy_point.global_position
					await get_tree().create_timer(0.1).timeout
		await get_tree().create_timer(2.71).timeout
func _bird_born() -> void:
	if GlobalsNode.unobstructed:
		return
	while begin:
		if not (in_esc or end):
			var okey := randf_range(0.0, 300.0)
			if okey > 11.0:
				var bird := preload("res://enemy/bird/bird.tscn").instantiate()
				add_child(bird)
				bird.global_position.x = enemy_point.global_position.x
				bird.global_position.y = enemy_point.global_position.y - okey
		await get_tree().create_timer(2.0).timeout
func _meteorite_born() -> void:
	if GlobalsNode.unobstructed:
		return
	while begin:
		if not (in_esc or end):
			var okey := randf_range(0.0, 480.0)
			if okey > 16.0 and okey < 464.0:
				var meteorite := preload("res://enemy/bullet/meteorite/meteorite.tscn").instantiate()
				add_child(meteorite)
				meteorite.global_position.x = global_position.x + okey
				meteorite.global_position.y = global_position.y
				meteorite.velocity = meteorite.global_position.direction_to(player_position)
		await get_tree().create_timer(1.618).timeout
func _cloud_born() -> void:
	var r = randi_range(4, 11)
	for i in r:
		var x := randf_range(16.0, 464.0)
		var y := randf_range(50.0, 284.0)
		var cloud := preload("res://scenes/main/cloud/cloud.tscn").instantiate()
		add_child(cloud)
		cloud.global_position.x = global_position.x + x
		cloud.global_position.y = global_position.y + y
	while true:
		if not (in_esc or end):
			var okey := randf_range(0.0, 300.0)
			if okey > 50.0 and okey < 284.0:
				var _cloud := preload("res://scenes/main/cloud/cloud.tscn").instantiate()
				add_child(_cloud)
				_cloud.global_position.x = enemy_point.global_position.x
				_cloud.global_position.y = enemy_point.global_position.y - okey
		await get_tree().create_timer(1 / GlobalsNode.speed).timeout
func _add_point() -> void:
	while begin:
		if not in_esc and not end:
			point += 1
			hi.text = "HI" + String.num_int64(point)
			if point == 100:
				var torch := preload("res://Player/torch/torch.tscn").instantiate()
				add_child(torch)
				torch.global_position.x = enemy_point.global_position.x
				torch.global_position.y = enemy_point.global_position.y - 4
			elif point >= 100 and not smileysed:
				smileysed = true
				var smileys := preload("res://enemy/boss/smileys/smileys.tscn").instantiate()
				add_child(smileys)
				var tween = create_tween()
				smileys.global_position = Vector2(375, -100)
				tween.tween_property(smileys, "global_position", Vector2(375, 155), 1)
				await tween.finished
				smileys.begin = true
		await get_tree().create_timer(0.1 / GlobalsNode.speed).timeout
func _do_a_barrel_roll() -> void:
	await get_tree().create_timer(1).timeout
	var tween1 = create_tween()
	var tween2 = create_tween()
	tween1.tween_property(camera_2d, "rotation", PI*2, 0.618)
	tween2.tween_property(_floor, "rotation", -PI*2, 0.618)
	await tween2.finished
	camera_2d.rotation = 0
	_floor.rotation = 0
func _on_player_die() -> void:
	end = true
	GlobalsMusic.sudden_battle.stop()
	var over := preload("res://ui/game_over/game_over.tscn").instantiate()
	add_child(over)
func _on_accelerate_toggled(_toggled_on: bool) -> void:
	if _toggled_on:
		GlobalsNode.speed = 2.0
	else :
		GlobalsNode.speed = 1.0
func _on_unobstructed_toggled(_toggled_on: bool) -> void:
	if _toggled_on:
		GlobalsNode.unobstructed = true
	else :
		GlobalsNode.unobstructed = false
func _on_invincible_toggled(_toggled_on: bool) -> void:
	if _toggled_on:
		GlobalsNode.OP = true
	else :
		GlobalsNode.OP = false
func _on_out_game_pressed() -> void:
	get_tree().quit()
func _on_go_on_pressed() -> void:
	_exit_esc()
func _on_out_pressed() -> void:
	get_tree().paused = false
	save_operate.save_game()
	var tree := get_tree()
	tree.change_scene_to_file("res://scenes/main/main.tscn")
