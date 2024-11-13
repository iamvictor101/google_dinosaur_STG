extends Enemy
enum STATE {
	IDLE,
}
var speed := 101.0
func _ready() -> void:
	add_to_group("enemies")
	speed = randf_range(101.0, 200.0)
func tick_physics(state: STATE, _delta: float) -> void:
	global_position.x -= _delta * speed * GlobalsNode.speed
	match state:
		STATE.IDLE:
			pass
func get_next_state(state: STATE) -> STATE:
	match state:
		STATE.IDLE:
			pass
	return state
func transition_state(_from: STATE, _to: STATE) -> void:
	match _to:
		STATE.IDLE:
			pass
func _on_hurtbox_hurt(_hitbox: Hitbox) -> void:
	var feather := preload("res://enemy/bird/feather.tscn").instantiate()
	get_parent().add_child(feather)
	feather.global_position = global_position
	queue_free()
func _on_timer_timeout() -> void:
	queue_free()
