class_name Stats
extends Node
@export var max_health: int = 1
#@onready的初始化在@export之后
@onready var health: int = max_health:
	set(v):
		v = clamp(v, 0, max_health)
		if health == v:
			return
		else:
			health = v
