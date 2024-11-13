extends CPUParticles2D
func _ready() -> void:
	_clear()
func _clear() -> void:
	await get_tree().create_timer(2.0).timeout
	queue_free()
