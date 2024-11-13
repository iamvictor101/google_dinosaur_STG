extends CPUParticles2D
func _ready() -> void:
	emitting = true
	await get_tree().create_timer(0.1).timeout
	_bron()
	await get_tree().create_timer(6.0).timeout
	queue_free()
func _bron() -> void:
	var r_num := randi_range(3, 11)
	for i in r_num:
		var alien := preload("res://enemy/alien/alien.tscn").instantiate()
		get_parent().add_child(alien)
		alien.global_position = global_position
		alien.v0 = Vector2(randf_range(-1, 1), randf_range(-1, 1))*randf_range(10, 36)
