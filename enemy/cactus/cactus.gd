extends Enemy
enum STATE {
	IDLE,
}
var size: int
func _ready() -> void:
	add_to_group("enemies")
	size = randi_range(0, 10)
	sprite_2d.frame = size
	if size == 0:
		hitbox.get_node("s").disabled = false
		hurtbox.get_node("s").disabled = false
		
	elif size > 0 and size <= 4:
		hitbox.get_node("m").disabled = false
		hurtbox.get_node("m").disabled = false
	elif size >= 5:
		hitbox.get_node("l").disabled = false
		hurtbox.get_node("l").disabled = false
func tick_physics(state: STATE, _delta: float) -> void:
	global_position.x -= _delta * 100 * GlobalsNode.speed
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
	var piece := preload("res://enemy/cactus/piece.tscn").instantiate()
	get_parent().add_child(piece)
	piece.global_position.x = global_position.x
	piece.global_position.y = global_position.y - 15
	piece.emitting = true
	queue_free()
func _on_timer_timeout() -> void:
	queue_free()
