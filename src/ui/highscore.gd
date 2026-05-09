extends CanvasLayer

var current_highscore: int = 0
var current_multiplyer: float = 1
var streak = 0
var combo_number_scene: PackedScene =  preload("res://src/ui/combo_number.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$Highscore.text = str(current_highscore)
	$Label.text = str(Engine.get_frames_per_second())

func combo(_id: int) -> void:
	current_multiplyer *= 1.5;
	var mul: RichTextLabel = combo_number_scene.instantiate()
	mul.text = "x" + str(streak + 1)#str(float(int(current_multiplyer * 100))/100.0)
	$mul_numbers.add_child(mul)
	mul.pivot_offset = mul.size/2
	mul.global_position = $mul_numbers/Marker2D.global_position + Vector2(randf_range(-200, 200) -200, randf_range(-200, 200))
	var tween = get_tree().create_tween()
	tween.tween_property(mul, "scale", Vector2(1.5 + 0.3 * streak, 1.5 + 0.3 * streak), 1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_callback(mul.queue_free)
	$ComboAudio.pitch_scale = 1.0 * pow(1.059, 2* (streak - 1)) + randf_range(-0.005, 0.005)
	$ComboAudio.volume_linear = 1.0 + 0.15 * streak
	$ComboAudio.play()
	streak += 1
	
func score_increase() -> void:
	var new_highscore = current_highscore + 10 * current_multiplyer
	current_multiplyer = 1
	streak = 0;
	var tween_up = get_tree().create_tween()
	tween_up.set_parallel()
	tween_up.tween_property(self, "current_highscore", new_highscore, 1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	#tween_up.tween_property($Highscore, "scale", Vector2(1.5, 1.5), 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	#tween_up.tween_property($Highscore, "modulate", Color(1.0, 0.0, 0.0, 1.0), 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	#var tween_set = get_tree().create_tween()
	#tween_set.tween_property($Highscore, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.1)
	#tween_set.tween_property($Highscore, "scale", Vector2(1.0, 1.0), 0.1)
	
