extends Node2D
@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D
func _ready() -> void:
	cpu_particles_2d.emitting = true
func _on_timer_timeout() -> void:
	queue_free()
