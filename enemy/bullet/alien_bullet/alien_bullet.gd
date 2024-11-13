extends Node2D
var speed := 300.0
var velocity: Vector2:
	set(v):
		velocity = v
		rotation = velocity.angle()#转向
func _process(_delta: float) -> void:
	global_position += velocity * speed * GlobalsNode.speed * _delta
func _on_hitbox_hit(_hurtbox: Variant) -> void:
	var die := preload("res://particle/alien/alien_die.tscn").instantiate()
	get_parent().add_child(die)
	die.global_position = global_position
	queue_free()
func _on_area_2d_body_entered(_body: Node2D) -> void:
	var die := preload("res://particle/alien/alien_die.tscn").instantiate()
	get_parent().add_child(die)
	die.global_position = global_position
	queue_free()
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
