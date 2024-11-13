extends CanvasLayer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
func _process(_delta: float) -> void:
	animated_sprite_2d.global_position = animated_sprite_2d.get_global_mouse_position()
	animated_sprite_2d.global_position.y += 1
	animated_sprite_2d.global_position.x += 1
