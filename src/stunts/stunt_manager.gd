class_name StuntManager
extends CanvasLayer


signal quick_time_event(idx: int)


@export var object: Node3D
@export var height_threshold: float = 5.0
@export var stunt_delay: float = 0.8
@export var quick_time: float = 1.0
@export var slowmo: bool = true
@export var slowmo_scale: float = 0.3


var qte_active: bool = false
var quick_timer: float = 0.0
var stunt_timer: float = 0.0
var tween: Tween
var key_tween: Tween

var qt_type: int = -1
var hit_key: int = -1

var hit_top: bool = false
var hit_back: bool = false
var hit_left: bool = false
var hit_right: bool = false
var multikey: bool = false


@onready var top: TextureRect = %Top
@onready var left: TextureRect = %Left
@onready var back: TextureRect = %Back
@onready var right: TextureRect = %Right
@onready var vignette: TextureRect = %Vignette
@onready var keys: Control = %Keys



func _process(delta: float) -> void:
	if not qte_active:
		stunt_timer += delta
		if object.global_position.y > height_threshold and stunt_timer > stunt_delay:
			qte_active = true
			if slowmo:
				Engine.time_scale = slowmo_scale
			if tween:
				tween.kill()
			tween = get_tree().create_tween()
			tween.set_parallel(true)
			tween.tween_property(vignette, "self_modulate", Color(1.0, 1.0, 1.0, 1.0), quick_time / 2.0).set_trans(Tween.TRANS_QUAD)
			
			qt_type = randi_range(0, 7)
			match qt_type:
				0:
					back.show()
					left.show()
					multikey = true
				1:
					top.show()
				2:
					back.show()
					right.show()
					multikey = true
				3:
					back.show()
				4:
					left.show()
				5:
					right.show()
				6:
					top.show()
					left.show()
					multikey = true
				7:
					top.show()
					right.show()
					multikey = true
		return
	
	quick_timer += delta
	
	
	if multikey:
		if hit_back and hit_left:
			hit_key = 0
		if hit_back and hit_right:
			hit_key = 2
		if hit_top and hit_left:
			hit_key = 6
		if hit_top and hit_right:
			hit_key = 7
	else:
		if hit_top:
			hit_key = 1
		if hit_back:
			hit_key = 3
		if hit_left:
			hit_key = 4
		if hit_right:
			hit_key = 5
	
	
	if hit_key == qt_type:
		#prints("hit", hit_key, qt_type)
		quick_time_event.emit(qt_type)
		hide_arrows()
		animate_keys(true)
	elif hit_key != -1:
		#print("miss")
		hide_arrows()
		animate_keys(false)
	
	if quick_timer > quick_time or object.global_position.y < height_threshold:
		#print("deactive")
		hide_arrows()
		animate_keys(false)


func _unhandled_input(event: InputEvent) -> void:
	if not qte_active:
		return

	if event.is_action_pressed("qt_top"):
		hit_top = true
	if event.is_action_pressed("qt_back"):
		hit_back = true
	if event.is_action_pressed("qt_left"):
		hit_left = true
	if event.is_action_pressed("qt_right"):
		hit_right = true


func hide_arrows() -> void:
	if slowmo:
		Engine.time_scale = 1.0
	if tween:
		tween.kill()
	vignette.self_modulate = Color(1.0, 1.0, 1.0, 0.0)
	
	hit_top = false
	hit_back = false
	hit_left = false
	hit_right = false
	multikey = false
	
	qt_type = -1
	hit_key = -1
	qte_active = false
	quick_timer = 0.0
	stunt_timer = 0.0


func animate_keys(hit: bool) -> void:
	if key_tween:
		key_tween.kill()
	key_tween = get_tree().create_tween()
	key_tween.set_parallel(true)
	if hit:
		key_tween.tween_property(keys, "scale", Vector2(1.2, 1.2), 0.1)\
			.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
		key_tween.tween_property(keys, "modulate", Color(1.0, 1.0, 0.0), 0.1)\
			.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	else:
		key_tween.tween_property(keys, "scale", Vector2(0.6, 0.6), 0.1)\
			.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
		key_tween.tween_property(keys, "modulate", Color(1.0, 0.0, 0.0), 0.1)\
			.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	await key_tween.finished
	
	top.hide()
	left.hide()
	back.hide()
	right.hide()
	
	keys.scale = Vector2(1.0, 1.0)
	keys.modulate = Color(0.0, 0.0, 0.0)
