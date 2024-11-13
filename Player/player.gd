class_name Player
extends CharacterBody2D
@export var facing := Face.RIGHT:
	set(v):
		facing = v
		if not is_node_ready():
			await ready
		body.scale.x = facing
@export var begin := false
@onready var stats: Stats = GlobalsNode.player_stats
@onready var save_operate: SaveOperate = GlobalsNode.save_operate
@onready var body: Node2D = $Body
@onready var sprite_2d: Sprite2D = $Body/Sprite2D
@onready var animation_player: AnimationPlayer = $Body/AnimationPlayer
@onready var hurtbox: Hurtbox = $Body/Hurtbox
@onready var fly_pos: Marker2D = $Body/Hurtbox/fly/fly_pos
@onready var sfx: Node = $sfx
@onready var coyotetime: Timer = $coyotetime
@onready var prejump: Timer = $prejump
@onready var down_pressed: Timer = $down_pressed
@onready var state_machine: StateMachine = $StateMachine
enum Face{
	RIGHT = 1,
	LEFT = -1,
}
enum STATE {
	IDLE,
	STAND,
	RUN,
	JUMP,
	FLY,
	DIE,
}
const on_floor_state := [STATE.STAND,STATE.RUN,]
const in_sky_state := [STATE.JUMP,]
#统计在空中的状态
const running_state := [STATE.RUN,]
#统计跑步时的状态
const speed_run := 1.618 * 6.626 * 10.0 + 100.0#黄金比例*普朗克常数/10的-34次方，再*10+100
const speed_sprint := 2.718281828 * 540.0 / 10.0 + 30.0#欧拉数*1发光强度的单色辐射源在给定方向上的频率/10的12次方，再/10+30
const speed_jump := -0.5772 * 6.67430 * 100.0 - 50.0#欧拉-马斯克若尼常数*牛顿常数/10的-11次方，再*100+50
const acceleration_floor := speed_run / 0.2
const acceleration_sky := speed_run / 0.02
var speed_direction#跑步左右方向
var x_direction#x方向
var y_direction#y方向
var fend_direction#击退方向
var G:=ProjectSettings.get("physics/2d/default_gravity") as float
var first_tick := false
#解决跳跃高度在get_next_state函数中的执行产生的损耗问题
var pending_damage: Damamge#记录伤害
var player_position#时刻玩家的位置
@warning_ignore("unused_signal")
signal die()#死亡信号
func _ready() -> void:
	add_to_group("player")#给玩家放入组中
func _unhandled_input(event: InputEvent) -> void:
	#if event.is_action_pressed("attack"):
		##如果这里监视不到鼠标的按键，可能你点到了ColorRect节点，将该节点的Mouse中的Filter属性改为Ignore即可
		#print("这句话是用来检测鼠标能是否正常点击")
	if stats.health != 0:
		if event.is_action_pressed("jump"):
			prejump.start()
		#预留跳跃按键
		if event.is_action_released("jump") and velocity.y < speed_jump / 2:
			velocity.y = speed_jump / 10
		#通过按jump的长短控制跳跃高度
		if event.is_action_pressed("down"):
			down_pressed.start()
		if event.is_action_released("down"):
			down_pressed.stop()
func tick_physics(state: STATE, delta: float) -> void:
#各状态下的运动逻辑,以及每帧要做的
	
	match state:
		STATE.IDLE:
			pass
		STATE.STAND:
			_move(G, delta)
			if down_pressed.time_left > 0:
				if animation_player.current_animation != "squat":
					animation_player.play("squat")
			else :
				animation_player.play("stand")
		STATE.RUN:
			_move(G, delta)
			if down_pressed.time_left > 0:
				if animation_player.current_animation != "squat":
					animation_player.play("squat")
			else :
				animation_player.play("run")
		STATE.JUMP:
			_move(0.0 if first_tick else G, delta)
			if down_pressed.time_left > 0:
				if animation_player.current_animation != "squat":
					animation_player.play("squat")
			else :
				animation_player.play("jump")
		STATE.FLY:
			_fly(delta)
		STATE.DIE:
			pass
	#
	if state != STATE.FLY:
		player_position = global_position
	else :
		player_position = fly_pos.global_position
	GlobalsSignal.emit_signal("player_position_update", player_position)
	#发送玩家位置
	first_tick = false
func _camera_shake(_time: float, _num: int, _range: float) -> void:
	#参数分别为：总时长，次数，幅度
	var _fv: float = _time / _num#频率
	var camera_2d = get_node("Camera2D")
	var i = 0
	while i < _num:
		var _add := Vector2(randf_range(-_range, _range), randf_range(-_range, _range)) 
		camera_2d.offset += _add
		await get_tree().create_timer(_fv).timeout
		camera_2d.offset -= _add
		i += 1
func _move(_g: float, _delta: float) -> void:
	speed_direction = Input.get_axis("move_l","move_r")
	var acceleration := acceleration_floor if is_on_floor() else acceleration_sky
	#判断地面和空中的加速度
	if velocity.y != 0 or (not is_zero_approx(speed_direction) and is_on_floor()):
		#这么多条件是为了防止人物在角落滑墙下来后走不动(不要改！删掉任何一点就没法正常移动了！)
		velocity.x = move_toward(velocity.x, speed_direction * speed_run, acceleration * _delta)
	#实现加速的起步和空中慢速
	else :
		velocity.x = move_toward(velocity.x, 0.0, acceleration * _delta)
	#
	if velocity.y < 520:
		if not is_on_floor():
			if down_pressed.time_left > 0:
				velocity.y = 520
			else :
				velocity.y += _delta * _g
	#临界落体速度
	move_and_slide()
	#此刻是该帧运动结束
func _fly(_delta: float) -> void:
	x_direction = Input.get_axis("move_l","move_r")
	y_direction = Input.get_axis("up", "down")
	if not is_zero_approx(x_direction):
		velocity.x = move_toward(velocity.x, x_direction * speed_run, acceleration_floor * _delta)
	else :
		velocity.x = move_toward(velocity.x, -x_direction * speed_run, acceleration_floor * _delta)
	if not is_zero_approx(y_direction):
		velocity.y = move_toward(velocity.y, y_direction * speed_run, acceleration_floor * _delta)
	else :
		velocity.y = move_toward(velocity.y, -y_direction * speed_run, acceleration_floor * _delta)
	move_and_slide()
func _fire() -> void:
	while true:
		if not get_parent().in_esc:
			var fireball := preload("res://Player/fireball/fireball.tscn").instantiate()
			get_parent().add_child(fireball)
			fireball.global_position.x = global_position.x + 14
			fireball.global_position.y = global_position.y + 4
		await get_tree().create_timer(0.2).timeout
func _die() -> void:
	die.emit()
func get_next_state(state: STATE) -> STATE:
#当前状态迁移到下一个状态的规则
	speed_direction = Input.get_axis("move_l","move_r")
	var is_stand := is_zero_approx(speed_direction) and is_on_floor()
	#记录是否在站立状态
	var is_jump := (is_on_floor() or coyotetime.time_left > 0) and prejump.time_left > 0
	#记录是否在跳跃状态
	if stats.health > 0:
		if GlobalsState.form == GlobalsState.FORM.RUN:
			if is_jump:
				velocity.y = speed_jump
				coyotetime.stop()
				sfx.get_node("jump").play()
				return STATE.JUMP
			#跳跃判断
			if state in on_floor_state and not is_on_floor():
				return STATE.JUMP
			#下落判断
		else :
			return STATE.FLY
	elif stats.health <= 0:
		return STATE.DIE
	#死亡
	match state:
		STATE.IDLE:
			if begin:
				GlobalsNode.in_ui = false#改变鼠标样子
				return STATE.STAND
		STATE.STAND:
			if not is_stand:
				return STATE.RUN
		STATE.RUN:
			if is_stand:
				return STATE.STAND
		STATE.JUMP:
			if is_stand or is_on_floor():
				return STATE.STAND
		STATE.FLY:
			pass
		STATE.DIE:
			pass
	return state
func transition_state(_from: STATE, _to: STATE) -> void:
#记录转换的两个状态，并规定每个状态的效果，这里写的效果都只触发一次
	#print("[%s] %s => %s" % [
		#Engine.get_physics_frames(),
		#STATE.keys()[_from] if _from != -1 else "<STATE>",
		#STATE.keys()[_to]
		#])
	#
	if _from in on_floor_state and _to in in_sky_state:
		coyotetime.start()
	#郊狼时间判断
	match _to:
		STATE.IDLE:
			pass
		STATE.STAND:
			animation_player.play("stand")
		STATE.RUN:
			animation_player.play("run")
		STATE.JUMP:
			animation_player.play("jump")
		STATE.FLY:
			animation_player.play("fly")
			_fire()
		STATE.DIE:
			pending_damage = null
			animation_player.play("die")
	first_tick = true
func _on_hurtbox_hurt(_hitbox: Hitbox) -> void:
	if GlobalsNode.OP:
		return
	pending_damage = Damamge.new()
	pending_damage.amount = _hitbox.atk
	pending_damage.power = _hitbox.power
	stats.health -= pending_damage.amount
	pending_damage.source = _hitbox.owner
	fend_direction = pending_damage.source.global_position.direction_to(global_position)
	
