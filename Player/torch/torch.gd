extends Interactive
func interact() -> void:
	GlobalsState.form = GlobalsState.FORM.FLY
	queue_free()
func _process(_delta: float) -> void:
	global_position.x -= _delta * 100 * GlobalsNode.speed
