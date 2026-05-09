extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ArrowDown"):
		show_ford()

func show_ford() -> void:
	$Ford.visible = true;
	var tween = get_tree().create_tween()
	tween.set_parallel()
	tween.tween_property($Ford, "rotation", $Ford.rotation + Vector3(0, 0, -6*PI), 1.0)
	tween.tween_property($Ford, "scale", Vector3(1,1,1), 1.0)
