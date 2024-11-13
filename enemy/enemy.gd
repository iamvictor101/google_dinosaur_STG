class_name Enemy
extends CharacterBody2D
@export var direction := Direction.LEFT:
	set(v):
		direction = v
		if not is_node_ready():
			await ready
		graphics.scale.x = -direction
@export var max_speed: float = 180#仅是规定一个默认值，下同
@export var acceleration: float = 2000
@onready var graphics: Node2D = $graphics
@onready var sprite_2d: Sprite2D = $graphics/Sprite2D
@onready var hitbox: Hitbox = $graphics/Hitbox
@onready var hurtbox: Hurtbox = $graphics/Hurtbox
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_listener_2d: AudioListener2D = $AudioListener2D
@onready var state_machine: StateMachine = $StateMachine
@onready var stats: Stats = $Stats
enum Direction{
	LEFT = -1,
	RIGHT = 1,
}
var G := ProjectSettings.get("physics/2d/default_gravity") as float
var pending_damage: Damamge#记录伤害
var live := true#判断死活
#func _ready() -> void:
	#add_to_group("enemies")#如果敌人本身有ready函数的话，这里的分组就会失效，我也不知道为什么
