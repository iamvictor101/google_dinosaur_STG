extends CPUParticles2D
func _ready() -> void:
	emitting = true
	await get_tree().create_timer(2.0).timeout
	queue_free()
