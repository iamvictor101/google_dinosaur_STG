class_name Interactive
extends Area2D
@export var enterd := false
@export var exited := false
var not_interact := false
func _init() -> void:
	collision_layer = 0
	collision_mask = 0
	set_collision_mask_value(2, true)
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
func interact() -> void:
	print("这是一个互动功能调试语句")
func _on_body_entered(_player: Node2D) -> void:
	if enterd:
		interact()
func _on_body_exited(_player: Node2D) -> void:
	if exited:
		interact()
