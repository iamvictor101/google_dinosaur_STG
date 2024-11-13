extends Enemy
@export var speed := 120.0
@export var v := Vector2.ZERO
var of_v: Vector2
var z: int
enum STATE {
	FLY,
}
var player_position := Vector2.ZERO
func _ready() -> void:
	modulate.a = 0.07
	z = randi_range(0, 1)
	if z==0:
		z=-1
	GlobalsSignal.connect("player_position_update", Callable(self, "player_position_record"))
	speed = randf_range(120, 150)
func tick_physics(state: STATE, _delta: float) -> void:
	if player_position.distance_to(global_position) <= 256:
		modulate.a = 0.07 + 36/player_position.distance_to(global_position)
	else :
		modulate.a = 0.07
	match state:
		STATE.FLY:
			velocity = v * speed * GlobalsNode.speed
			of_v.x = velocity.y/velocity.length()
			of_v.y = -velocity.x/velocity.length()
			velocity += of_v * z * 20.0 * cos(Time.get_ticks_msec() / 200.0)
	move_and_slide()
func player_position_record(pos):
	player_position = pos
func get_next_state(state: STATE) -> STATE:
	match state:
		STATE.FLY:
			pass
	return state
func transition_state(_from: STATE, _to: STATE) -> void:
	match _to:
		STATE.FLY:
			pass
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
