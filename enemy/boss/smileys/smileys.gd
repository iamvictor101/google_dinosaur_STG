extends Boss
@onready var fuck_pos: Marker2D = $graphics/fuck_pos
@onready var h_pos: Marker2D = $Node_2D/h_pos
@onready var l_pos: Marker2D = $Node_2D/L_pos
@onready var r_pos: Marker2D = $Node_2D/R_pos
@onready var eye_1: Marker2D = $Node_2D/eye1
@onready var eye_2: Marker2D = $Node_2D/eye2
@onready var heart: CharacterBody2D = $Node/heart
@onready var l: CharacterBody2D = $Node/hand/L
@onready var r: CharacterBody2D = $Node/hand/R
@onready var l_cast_2d: RayCast2D = $Node/hand/L/LCast2D
@onready var r_cast_2d: RayCast2D = $Node/hand/R/RCast2D
@onready var r_cast_2d_2: RayCast2D = $Node/hand/R/RCast2D2
@onready var canvas_layer: CanvasLayer = $CanvasLayer
enum STATE {
	IDLE,
	BORN,
	LEVEL_1,
	LEVEL_2,
	LEVEL_3,
	LEVEL_4,
	LEVEL_5,
	DIE,
}
var begin = false
var catch = true
var follow = true
var can_return = false
var shaked = false
var player_position := Vector2.ZERO
var s_y := 0# 距离玩家的距离的正负
func _ready() -> void:
	l.global_position = l_pos.global_position
	r.global_position = r_pos.global_position
	heart.global_position = h_pos.global_position
	GlobalsSignal.connect("player_position_update", Callable(self, "player_position_record"))
	GlobalsMusic.sudden_battle.play()
func player_position_record(pos):
	player_position = pos
func _set_follow(_v: bool) -> void:
	follow = _v
func _l_hand(_v: Vector2) -> void:
	l.get_node("Sprite2D").frame_coords = _v
func _r_hand(_v: Vector2) -> void:
	r.get_node("Sprite2D").frame_coords = _v
func _set_catch(_catch: bool) -> void:
	catch = _catch
func tick_physics(state: STATE, _delta: float) -> void:
	if not catch:
		heart.global_position.y += _delta * 100
	match state:
		STATE.IDLE:
			l.global_position = l_pos.global_position
			r.global_position = r_pos.global_position
			heart.global_position = h_pos.global_position
		STATE.BORN:
			l.global_position = l_pos.global_position
			r.global_position = r_pos.global_position
			if catch:
				heart.global_position = h_pos.global_position
		STATE.LEVEL_1:
			pass
		STATE.LEVEL_2:
			if animation_player.current_animation == "level1-2":
				if follow:
					l.global_position = l_pos.global_position
					r.global_position = r_pos.global_position
				else :
					if l_cast_2d.is_colliding() or r_cast_2d.is_colliding():
						if not shaked:
							shaked = true
							get_parent()._camera_shake(0.2, 5, 10.0)
						pass
					else :
						l.global_position.y += 300 * _delta
						r.global_position.y += 300 * _delta
			else :
				if global_position.y - player_position.y < 0:
					s_y = 1
				else :
					s_y = -1
				global_position.y += s_y * 50 * GlobalsNode.speed * _delta
				l.global_position = l_pos.global_position
				if r_cast_2d_2.is_colliding():
					$Node/hand/R/Hitbox/CollisionShape2D2.disabled = false
					r.global_position.y += 300 * _delta
				else :
					$Node/hand/R/Hitbox/CollisionShape2D2.disabled = true
					r.global_position += r.global_position.direction_to(player_position + Vector2(0, -50)) * 50 * GlobalsNode.speed * _delta
		STATE.LEVEL_3:
			l.global_position = l_pos.global_position
			r.global_position = r_pos.global_position
		STATE.LEVEL_4:
			pass
		STATE.LEVEL_5:
			pass
		STATE.DIE:
			pass
	move_and_slide()
func _level_1() -> void:
	var i = -1
	while true:
		if not (get_parent().in_esc or get_parent().end):
			i += 1
		if i <= 6:
			await get_tree().create_timer(1 / GlobalsNode.speed).timeout
			if (get_parent().in_esc or get_parent().end):
				continue
			var l_bullet1 := preload("res://enemy/bullet/l_bullet/l_bullet.tscn").instantiate()
			var l_bullet2 := preload("res://enemy/bullet/l_bullet/l_bullet.tscn").instantiate()
			get_parent().add_child(l_bullet1)
			get_parent().add_child(l_bullet2)
			l_bullet1.global_position = eye_1.global_position
			l_bullet2.global_position = eye_2.global_position
			l_bullet1.velocity = l_bullet1.global_position.direction_to(player_position)
			l_bullet2.velocity = l_bullet2.global_position.direction_to(player_position)
		elif i <= 9:
			await get_tree().create_timer(2 / GlobalsNode.speed).timeout
			for j in 11:
				await get_tree().create_timer(0.1 / GlobalsNode.speed).timeout
				if (get_parent().in_esc or get_parent().end):
					continue
				var l_bullet1 := preload("res://enemy/bullet/l_bullet/l_bullet.tscn").instantiate()
				var l_bullet2 := preload("res://enemy/bullet/l_bullet/l_bullet.tscn").instantiate()
				get_parent().add_child(l_bullet1)
				get_parent().add_child(l_bullet2)
				l_bullet1.global_position = eye_1.global_position
				l_bullet2.global_position = eye_2.global_position
				l_bullet1.velocity = l_bullet1.global_position.direction_to(player_position)
				l_bullet2.velocity = l_bullet2.global_position.direction_to(player_position)
				l_bullet1.speed = 500
				l_bullet2.speed = 500
		elif i <= 10:
			await get_tree().create_timer(3 / GlobalsNode.speed).timeout
			for j in 11:
				await get_tree().create_timer(1 / GlobalsNode.speed).timeout
				for k in 36 * 5:
					if (get_parent().in_esc or get_parent().end):
						continue
					var l_bullet := preload("res://enemy/bullet/l_bullet/l_bullet.tscn").instantiate()
					get_parent().add_child(l_bullet)
					l_bullet.get_node("AudioListener2D").get_node("AudioStreamPlayer2D").volume_db = -40
					l_bullet.global_position = eye_1.global_position if j % 2 == 0 else eye_2.global_position
					l_bullet.velocity.x = cos(k * TAU/36*5)
					l_bullet.velocity.y = sin(k * TAU/36*5)
					l_bullet.speed = randf_range(100, 150)
		elif i <= 21:
			await get_tree().create_timer(1 / GlobalsNode.speed).timeout
			for j in 36 * 5:
				if (get_parent().in_esc or get_parent().end):
					continue
				var l_bullet := preload("res://enemy/bullet/l_bullet/l_bullet.tscn").instantiate()
				get_parent().add_child(l_bullet)
				l_bullet.get_node("AudioListener2D").get_node("AudioStreamPlayer2D").volume_db = -40
				l_bullet.global_position = eye_1.global_position if i % 2 == 0 else eye_2.global_position
				l_bullet.velocity.x =cos(j + 0.5 * TAU/36*5)
				l_bullet.velocity.y =sin(j + 0.5 * TAU/36*5)
				l_bullet.speed = randf_range(100, 150)
		else :
			can_return = true
			break
func _level_2() -> void:
	var i = 0
	while true:
		if not (get_parent().in_esc or get_parent().end):
			i += 1
			if i < 20:
				await get_tree().create_timer(1 / GlobalsNode.speed).timeout
				var fuck := preload("res://enemy/bullet/fuck/fuck.tscn").instantiate()
				get_parent().add_child(fuck)
				fuck.v = Vector2(-1, 0)
				fuck.global_position = fuck_pos.global_position
			elif i < 29:
				await get_tree().create_timer(2 / GlobalsNode.speed).timeout
				for j in 3:
					await get_tree().create_timer(0.1 / GlobalsNode.speed).timeout
					var fuck := preload("res://enemy/bullet/fuck/fuck.tscn").instantiate()
					get_parent().add_child(fuck)
					fuck.v = Vector2(-1, 0)
					fuck.speed = 300
					fuck.global_position = fuck_pos.global_position
			else :
				can_return = true
				break
		else :
			await get_tree().create_timer(2 / GlobalsNode.speed).timeout
func _level_3_1() -> void:
	var circle_l := preload("res://enemy/goods/circle/circle.tscn").instantiate()
	get_parent().add_child(circle_l)
	circle_l.velocity = Vector2(0, -1)
	circle_l.form = 2
	circle_l.global_position = l_pos.global_position
	var circle_r := preload("res://enemy/goods/circle/circle.tscn").instantiate()
	get_parent().add_child(circle_r)
	circle_r.velocity = Vector2(0, -1)
	circle_r.form = 2
	circle_r.global_position = r_pos.global_position
func _level_3_2() -> void:
	var _i = 0
	while true:
		if not (get_parent().in_esc or get_parent().end):
			_i += 1
			if _i < 99:
				await get_tree().create_timer(0.3 / GlobalsNode.speed).timeout
				var ghost := preload("res://enemy/ghost/ghost.tscn").instantiate()
				get_parent().add_child(ghost)
				ghost.v = Vector2(0, 1)
				ghost.global_position = Vector2(randf_range(0, 480), 0)
			else :
				break
		else :
			await get_tree().create_timer(1 / GlobalsNode.speed).timeout
func _level_3_3() -> void:
	var k = 5
	for i in k+1:
		var circle := preload("res://enemy/goods/circle/circle.tscn").instantiate()
		get_parent().add_child(circle)
		circle.velocity = Vector2(0, -1)
		circle.form = 1
		circle.global_position = Vector2(0 + (i) * 96, 300)
	canvas_layer.visible = true
func get_next_state(state: STATE) -> STATE:
	match state:
		STATE.IDLE:
			if begin:
				return STATE.BORN
		STATE.BORN:
			if animation_player.assigned_animation == "born" and not animation_player.is_playing():
				return STATE.LEVEL_1
		STATE.LEVEL_1:
			if can_return:
				can_return = false
				return STATE.LEVEL_2
		STATE.LEVEL_2:
			if can_return:
				can_return = false
				return STATE.LEVEL_3
		STATE.LEVEL_3:
			if can_return:
				can_return = false
				return STATE.LEVEL_3
		STATE.LEVEL_4:
			if can_return:
				can_return = false
				return STATE.LEVEL_3
		STATE.LEVEL_5:
			if can_return:
				can_return = false
				return STATE.LEVEL_3
		STATE.DIE:
			if can_return:
				can_return = false
				return STATE.LEVEL_3
	return state
func transition_state(_from: STATE, _to: STATE) -> void:
	match _to:
		STATE.IDLE:
			pass
		STATE.BORN:
			animation_player.play("born")
		STATE.LEVEL_1:
			animation_player.play("level_1")
			_level_1()
		STATE.LEVEL_2:
			animation_player.play("level1-2")
		STATE.LEVEL_3:
			animation_player.play("level2-3")
			var tween = create_tween()
			tween.tween_property(self, "global_position", Vector2(240.0, 150.0), 1.4)
		STATE.LEVEL_4:
			pass
		STATE.LEVEL_5:
			pass
		STATE.DIE:
			pass
func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	if _anim_name == "level1-2":
		animation_player.play("angry")
		l.global_position = l_pos.global_position
		r.global_position = r_pos.global_position
		_level_2()
func _on_h_area_2d_body_entered(_body: Node2D) -> void:
	heart.visible = false
	var scrap := preload("res://particle/h_scrap/h_scrap.tscn").instantiate()
	get_parent().add_child(scrap)
	scrap.global_position = heart.global_position
	scrap.emitting = true
