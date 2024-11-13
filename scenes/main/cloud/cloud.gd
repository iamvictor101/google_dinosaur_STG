extends Node2D
@onready var marker_2d: Marker2D = $Marker2D
func _ready() -> void:
	if get_parent().begin and GlobalsNode.unobstructed == false:
		var r := randf_range(0.0, 30.0 - GlobalsNode.turtle_f)
		if r <= 1.0:
			var cloud_turtle := preload("res://enemy/turtle/cloud_turtle/cloud_turtle.tscn").instantiate()
			add_child(cloud_turtle)
			cloud_turtle.global_position = marker_2d.global_position
func _process(_delta: float) -> void:
	global_position.x -= _delta * 20 * GlobalsNode.speed
func _on_timer_timeout() -> void:
	queue_free()
