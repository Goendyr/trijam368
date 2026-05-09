extends Node3D

var stunting: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



func stunt(idx: int) -> void:
	stunting = true
	$StuntTimer.start()
	match (idx):
		0: left_spin_y()
		1: forward_spin() 
		2: right_spin_y()
		3: backward_spin()
		4: barrel_left()
		5: barrel_right()
		6: twisting_left()
		7: twisting_right()

func squish() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector3(1.2, 0.4, 1.2), 0.05)\
	.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector3(1.0, 1.0, 1.0), 0.15)\
	.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)

# STUNTS
func left_spin_y() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property($".", "rotation", rotation + Vector3(0, 2*PI, 0), 0.3)
	
func right_spin_y() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property($".", "rotation", rotation - Vector3(0, 2*PI, 0), 0.3)
	
func forward_spin() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property($".", "rotation", rotation + Vector3(0, 0, 2*PI), 0.3)
	
func backward_spin() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property($".", "rotation", rotation - Vector3(0, 0, 2*PI), 0.3)

func barrel_left() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property($".", "rotation", rotation + Vector3(2*PI, 0, 0), 0.3)
	
func barrel_right() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property($".", "rotation", rotation - Vector3(2*PI, 0, 0), 0.3)
	
func twisting_left() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property($".", "rotation", rotation + Vector3(2*PI, 0, 2*PI), 0.8)

func twisting_right() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property($".", "rotation", rotation - Vector3(2*PI, 0, 2*PI), 0.6)


func _on_stunt_timer_timeout() -> void:
	stunting = false
