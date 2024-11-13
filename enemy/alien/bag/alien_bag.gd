extends Node2D
@onready var animation_player: AnimationPlayer = $Node2D/AnimationPlayer
@onready var cpu_particles_2d: CPUParticles2D = $Node2D/CPUParticles2D
@export var velocity: Vector2:
		set(v):
			velocity = v
			rotation = velocity.angle()#转向
var speed := 200.0
func _ready() -> void:
	cpu_particles_2d.emitting = true
func _process(_delta: float) -> void:
	global_position += velocity * speed * GlobalsNode.speed * _delta
	cpu_particles_2d.gravity = -velocity * 100
func _on_hurtbox_hurt(_hitbox: Variant) -> void:
	var bomb := preload("res://particle/alien/alien_bomb.tscn").instantiate()
	get_parent().add_child(bomb)
	bomb.global_position = global_position
	cpu_particles_2d.emitting = false
	animation_player.play("free")
func _on_area_2d_body_entered(_body: Node2D) -> void:
	var bomb := preload("res://particle/alien/alien_bomb.tscn").instantiate()
	get_parent().add_child(bomb)
	bomb.global_position = global_position
	cpu_particles_2d.emitting = false
	animation_player.play("free")
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	cpu_particles_2d.emitting = false
	animation_player.play("free")
