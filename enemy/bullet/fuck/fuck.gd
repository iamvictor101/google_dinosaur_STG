extends Node2D
@onready var sprite_2d: Sprite2D = $Sprite2D
var speed := 200.0
var v: Vector2
func _ready() -> void:
	sprite_2d.frame = randi_range(0, 7)
	global_rotation = randf_range(PI / -8, PI / 8)
func _process(_delta: float) -> void:
	global_position += v * speed * GlobalsNode.speed * _delta
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
