extends Control
@onready var animation_player: AnimationPlayer = $AnimationPlayer
func _ready() -> void:
	GlobalsNode.in_ui = true
func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	var tree := get_tree()
	tree.change_scene_to_file("res://scenes/main/main.tscn")
