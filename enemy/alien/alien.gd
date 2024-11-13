extends Enemy
var v0 := Vector2.ZERO
var speed := 0.0
var pursue := false
enum STATE {
	FLY,
}
var player_position := Vector2.ZERO
func _ready() -> void:
	GlobalsSignal.connect("player_position_update", Callable(self, "player_position_record"))
	fire()
func player_position_record(pos):
	player_position = pos
func tick_physics(state: STATE, _delta: float) -> void:
	if pursue:
		if global_position.distance_to(player_position) < 110.0:
			speed = move_toward(speed, -200.0, 10*GlobalsNode.speed)
		else :
			speed = move_toward(speed, 200.0, 10*GlobalsNode.speed)
		velocity.x = global_position.direction_to(player_position).x + randf_range(-1, 1)
		velocity.y = global_position.direction_to(player_position).y + randf_range(-1, 1)
		velocity *= speed
	else :
		velocity = v0
	match state:
		STATE.FLY:
			pass
	move_and_slide()
func fire() -> void:
	await get_tree().create_timer(2.71/GlobalsNode.speed).timeout
	pursue = true
	while true:
		await get_tree().create_timer(randf_range(2.71, 4.2)/GlobalsNode.speed).timeout
		var bullet := preload("res://enemy/bullet/alien_bullet/alien_bullet.tscn").instantiate()
		get_parent().add_child(bullet)
		bullet.global_position = global_position
		bullet.velocity = global_position.direction_to(player_position)
func get_next_state(state: STATE) -> STATE:
	match state:
		STATE.FLY:
			pass
	return state
func transition_state(_from: STATE, _to: STATE) -> void:
	match _to:
		STATE.FLY:
			pass
func _on_hurtbox_hurt(_hitbox: Variant) -> void:
	var die := preload("res://particle/alien/alien_die.tscn").instantiate()
	get_parent().add_child(die)
	die.global_position = global_position
	die.scale *= 2
	queue_free()
