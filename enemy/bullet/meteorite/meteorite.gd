extends RigidBody2D
var speed_1 := 10.0
var speed_2 := 1000.0
var speed: float
var velocity: Vector2
func _ready() -> void:
	_turn_speed()
func _process(_delta: float) -> void:
	global_position += velocity * speed * _delta
func _turn_speed() -> void:
	speed = speed_1
	await get_tree().create_timer(3.14 / GlobalsNode.speed).timeout
	speed = speed_2
func _on_hitbox_hit(_hurtbox: Variant) -> void:
	var piece := preload("res://enemy/bullet/meteorite/piece.tscn").instantiate()
	get_parent().add_child(piece)
	piece.global_position = global_position
	piece.emitting = true
	queue_free()
func _on_area_2d_body_entered(_body: Node2D) -> void:
	var piece := preload("res://enemy/bullet/meteorite/piece.tscn").instantiate()
	get_parent().add_child(piece)
	piece.global_position = global_position
	piece.emitting = true
	queue_free()
func _on_timer_timeout() -> void:
	queue_free()
