extends Enemy
@export var in_idle := true
enum STATE {
	IDLE,
	FLY,
	RUN,
}
func tick_physics(state: STATE, _delta: float) -> void:
	match state:
		STATE.IDLE:
			pass
		STATE.FLY:
			velocity.y += G * _delta
		STATE.RUN:
			velocity.x = -150.0 * GlobalsNode.speed
			velocity.y = 0.0
	move_and_slide()
func get_next_state(state: STATE) -> STATE:
	match state:
		STATE.IDLE:
			if not in_idle:
				return STATE.FLY
		STATE.FLY:
			if is_on_floor():
				return STATE.RUN
		STATE.RUN:
			pass
	return state
func transition_state(_from: STATE, _to: STATE) -> void:
	match _to:
		STATE.IDLE:
			animation_player.play("idle")
		STATE.FLY:
			animation_player.play("fly")
		STATE.RUN:
			animation_player.play("run")
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
