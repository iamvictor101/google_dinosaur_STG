extends CPUParticles2D


func _on_timer_timeout() -> void:
	queue_free()
