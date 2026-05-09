extends Node3D

@export
var crawl_speed = 5.3
var wiggle_duration = 0.5

var crawl_l: Tween
var crawl_r: Tween
var wiggle: Tween
var move: Tween
var turn: Tween
var limbs_right: Node3D
var limbs_left: Node3D
var body: Node3D

var crawl_dir: Vector3
@export var turn_speed = 1.5
@export var turn_frequency = 8
var rng = RandomNumberGenerator.new()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	limbs_left = $body/limbs_left
	limbs_right = $body/limbs_right
	body = $"body"
	
	# make infinitely looping crawl animation loop
	#legs
	crawl_l = get_tree().create_tween().set_loops() 
	crawl_l.set_parallel(false)
	crawl_l.tween_property(limbs_left, "position", \
	limbs_left.position + Vector3(-0.13, 0.0, 0.0), wiggle_duration) \
	.set_trans(Tween.TRANS_QUAD)
	crawl_l.tween_property(limbs_left, "position", \
	limbs_left.position +Vector3(0.0, 0.0, 0.0), wiggle_duration) \
	.set_trans(Tween.TRANS_QUAD)
	
	crawl_r = get_tree().create_tween().set_loops() 
	crawl_r.set_parallel(false)
	crawl_r.tween_property(limbs_right, "position", \
	limbs_right.position +Vector3(0.13, 0.0, 0.0), wiggle_duration) \
	.set_trans(Tween.TRANS_QUAD)
	crawl_r.tween_property(limbs_right, "position", \
	limbs_right.position +Vector3(0.0, 0.0, 0.0), wiggle_duration) \
	.set_trans(Tween.TRANS_QUAD)
	
	# body wiggle
	wiggle = get_tree().create_tween().set_loops()
	wiggle.tween_property(body, "rotation", \
	Vector3(0, deg_to_rad(-3), 0), wiggle_duration) \
	.as_relative().set_trans(Tween.TRANS_QUAD)
	wiggle.tween_property(body, "rotation", \
	Vector3(0, deg_to_rad(3), 0), wiggle_duration)\
	.as_relative().set_trans(Tween.TRANS_QUAD)

	gen_set_crawl_dir()
	
func _process(delta: float) -> void:
	if not body.visible:
		return
	# crawl
	position += crawl_dir.normalized() * crawl_speed * delta
	# turn
	if crawl_dir != Vector3.ZERO:
		var target_basis = Basis.looking_at(crawl_dir.rotated(Vector3.UP, deg_to_rad(90)))
		basis = basis.orthonormalized().slerp(target_basis, delta * turn_speed)

func gen_set_crawl_dir() -> void:
	crawl_dir = Vector3(\
	rng.randf_range(-1, 1),\
	0,
	rng.randf_range(-1, 1)).normalized()
	#look_at(global_transform.origin + crawl_dir)
	#var turn = get_tree().create_tween().tween_property($".", rotation, crawl_dir, 1)
	
	#rotate(Vector3.UP, 90)
	await get_tree().create_timer(turn_frequency).timeout
	gen_set_crawl_dir()


func _on_area_3d_body_entered(body_: Node3D) -> void:
	if body_.has_method("start_control"):
		body_.start_control()
	if body_.has_method("jump"):
		body_.jump()
		$BloodExplosion.splatter()
		crawl_l.stop()
		crawl_r.stop()
		wiggle.stop()
		$body.hide()
		set_deferred("$Area3D.monitoring ", false)
		$AudioStreamPlayer3D.play()
		await get_tree().create_timer(60.0).timeout
		self.queue_free()


func _exit_tree() -> void:
	crawl_l.kill()
	crawl_r.kill()
	wiggle.kill()
