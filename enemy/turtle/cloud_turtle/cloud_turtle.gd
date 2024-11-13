extends Enemy
@onready var marker_2d: Marker2D = $Marker2D
@export var in_idle := true
var die := false
var player_position := Vector2.ZERO
enum STATE {
	IDLE,
	BORN,
	STAND,
	DIE,
}
func _ready() -> void:
	GlobalsSignal.connect("player_position_update", Callable(self, "player_position_record"))
func tick_physics(state: STATE, _delta: float) -> void:
	match state:
		STATE.IDLE:
			pass
		STATE.BORN:
			pass
		STATE.STAND:
			pass
		STATE.DIE:
			velocity.y += G * _delta
			global_rotation += 2 * _delta
	move_and_slide()
func player_position_record(pos):
	player_position = pos
func _ttk() -> void:
	await get_tree().create_timer(1 / GlobalsNode.speed).timeout
	while not die:
		var turtle := preload("res://enemy/turtle/spiny_turtle/spiny_turtle.tscn").instantiate()
		add_child(turtle)
		turtle.global_position = marker_2d.global_position
		await get_tree().create_timer(2 / GlobalsNode.speed).timeout
		turtle.reparent(get_parent().get_parent())
		turtle.global_rotation = 0
		turtle.in_idle = false
		turtle.velocity = global_position.direction_to(player_position) * 500
		await get_tree().create_timer(2 / GlobalsNode.speed).timeout
func get_next_state(state: STATE) -> STATE:
	if stats.health <= 0:
		return STATE.DIE
	match state:
		STATE.IDLE:
			if not in_idle:
				return STATE.BORN
		STATE.BORN:
			if not animation_player.is_playing():
				return STATE.STAND
		STATE.STAND:
			pass
		STATE.DIE:
			pass
	return state
func transition_state(_from: STATE, _to: STATE) -> void:
	match _to:
		STATE.IDLE:
			animation_player.play("idle")
		STATE.BORN:
			animation_player.play("born")
		STATE.STAND:
			animation_player.play("stand")
			_ttk()
		STATE.DIE:
			get_parent().get_parent().point += 50
			die = true
			velocity = Vector2(1, -2) * 100
			animation_player.play("die")
func _on_area_2d_body_entered(_body: Node2D) -> void:
	if in_idle:
		in_idle = false
func _on_hurtbox_hurt(_hitbox: Variant) -> void:
	stats.health -= _hitbox.atk
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	die = true
	queue_free()
