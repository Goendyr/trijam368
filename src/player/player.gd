extends CharacterBody3D


const camera_angle = -16

# How fast the player moves in meters per second.
@export var max_speed = 10

@export var min_speed = 1

# acceleration in meters per second squared
@export var acceleration = 15

@export var boost = 3

# angle_change change per second
@export var angle_change = deg_to_rad(120)

# The downward acceleration when in the air, in meters per second squared.
@export var fall_acceleration = 9

@export var current_direction = Vector3.FORWARD

@export var active = false

signal destroyed

var _will_jump = false

var _allow_control = false

var _was_on_floor = false

func _ready():
	velocity = Vector3.ZERO
	
	#for node in get_tree().get_nodes_in_group("Bounce"):
	#	if node.has_signal("body_entered"):
	#		node.body_entered.connect(_on_bounce_body_entered)

func jump():
	_will_jump = true
	$"../Highscore".score_increase()
	$Pivot/FordFocusMesh.squish()

func start_control():
	if not _allow_control:
		_allow_control = true
		velocity = Vector3.FORWARD

func _reset():
	current_direction = Vector3.FORWARD
	_will_jump = false
	_allow_control = false

func _physics_process(delta):
	if not active:
		pass
	var movement_y = velocity.y
	var movement_xz = velocity
	movement_xz.y = 0

	if _allow_control:
		if Input.is_action_pressed("move_backward"):
			if movement_xz.length() > min_speed:
				movement_xz -= current_direction * acceleration * delta
		if Input.is_action_pressed("move_forward"):
			movement_xz += current_direction * acceleration * delta
		
		if Input.is_action_pressed("turn_right"):
			movement_xz = movement_xz.rotated(Vector3.UP, -angle_change * delta)
		if Input.is_action_pressed("turn_left"):
			movement_xz = movement_xz.rotated(Vector3.UP, angle_change * delta)
	
	if not movement_xz.is_equal_approx(Vector3.ZERO):
		# Setting the basis property will affect the rotation of the node.
		$Pivot.basis = Basis.looking_at(movement_xz)
		current_direction = movement_xz.normalized()
	
	if _will_jump and is_on_floor():
		movement_y += 10
		movement_xz += current_direction * boost
		_will_jump = false
	elif not _will_jump and is_on_floor():
		if _was_on_floor:
			destroyed.emit()
			$Explosion.explode()
		else:
			_was_on_floor = true
	else:
		_was_on_floor = false
			

	# Ground Velocity
	movement_xz = movement_xz.limit_length(max_speed)

	# Vertical Velocity
	if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
		movement_y = movement_y - (fall_acceleration * delta)


	velocity = movement_xz
	velocity.y  = movement_y
	# Moving the Character
	move_and_slide()

		

func _on_bounce_body_entered(body: Node3D) -> void:
	if body.has_method("start_control"):
		body.start_control()
	if body.has_method("jump"):
		body.jump()


func _on_stunt_manager_quick_time_event(idx: int) -> void:
	$Pivot/FordFocusMesh.stunt(idx)
