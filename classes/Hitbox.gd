class_name Hitbox
extends Area2D
signal hit(hurtbox)
@export var atk := 1
@export var power: float = 200
func _init() -> void:
	area_entered.connect(_is_area_entered)
func _is_area_entered(_hurtbox: Hurtbox) -> void:
	#print("[Hit] %s => %s" % [owner.name, hurtbox.owner.name])
	hit.emit(_hurtbox)
	_hurtbox.hurt.emit(self)
