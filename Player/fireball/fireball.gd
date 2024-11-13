extends RigidBody2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hitbox: Hitbox = $Hitbox
var speed := 400.0
var velocity := Vector2(1, 0)
var stop := false
func _ready() -> void:
	velocity *= speed
func _process(delta: float) -> void:
	if not stop:
		global_position += velocity * delta
func _on_hitbox_hit(_hurtbox: Variant) -> void:
	stop = true
	get_parent().point += 10
	animation_player.play("boom")
func _on_area_2d_body_entered(_body: Node2D) -> void:
	stop = true
	animation_player.play("boom")
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
