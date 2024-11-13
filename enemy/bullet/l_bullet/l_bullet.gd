extends Node2D
@export var speed := 200.0
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hitbox: Hitbox = $Hitbox
@onready var audio_listener_2d: AudioListener2D = $AudioListener2D
var velocity: Vector2:
	set(v):
		velocity = v
		rotation = velocity.angle()#转向
var rebounded := false
func _ready() -> void:
	audio_listener_2d.get_node("AudioStreamPlayer2D").play()
func _physics_process(delta: float) -> void:
	global_position += velocity * speed * GlobalsNode.speed * delta
func _on_hitbox_hit(_hurtbox: Variant) -> void:
	animation_player.play("boom")
	set_physics_process(false)
func _on_hitbox_body_entered(_body: Node2D) -> void:
	animation_player.play("boom")
	set_physics_process(false)
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "boom":
		queue_free()
#动画结束后消除子弹
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
