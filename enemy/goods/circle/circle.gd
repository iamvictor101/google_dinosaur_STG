extends Node2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@export var velocity: Vector2:
		set(v):
			velocity = v
			rotation = velocity.angle() + PI#转向
@export var form: int = 1
func _ready() -> void:
	if form == 1:
		animation_player.play("born_1")
	else :
		animation_player.play("born_2")
	_life_time()
func _life_time() -> void:
	await get_tree().create_timer(6.6).timeout
	queue_free()
func _launch() -> void:
	var r_num := randi_range(3, 11)
	var _offset: float
	var of_v: Vector2
	var cycle_t := 0.2
	while true:
		if not (get_parent().in_esc or get_parent().end):
			for i in r_num:
				_offset = randf_range(-13, 13)
				var ghost := preload("res://enemy/ghost/ghost.tscn").instantiate()
				get_parent().add_child(ghost)
				ghost.global_position = global_position
				of_v.x = velocity.y/velocity.length()
				of_v.y = -velocity.x/velocity.length()
				ghost.global_position += of_v * _offset
				if form == 1:
					ghost.v = velocity
				else :
					_offset = randf_range(-0.5, 0.5)
					ghost.v = velocity + of_v * _offset
		await get_tree().create_timer(cycle_t/GlobalsNode.speed).timeout
		cycle_t = randf_range(0.01, 0.2)
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "born_1":
		animation_player.play("launch_1")
	else :
		animation_player.play("launch_2")
	_launch()
