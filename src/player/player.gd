extends CharacterBody3D


const camera_angle = -16

# How fast the player moves in meters per second.
@export var max_speed = 10

@export var min_speed = 1

# acceleration in meters per second squared
@export var acceleration = 15

@export var boost = 3

# angle_change change per second
@export var angle_change = deg_to_rad(100)

# The downward acceleration when in the air, in meters per second squared.
@export var fall_acceleration = 9


var current_direction = Vector3.FORWARD

var will_jump = false

func _ready():
	velocity = Vector3.FORWARD
	for node in get_tree().get_nodes_in_group("Bounce"):
		if node.has_signal("body_entered"):
			node.body_entered.connect(_on_bounce_body_entered)


func jump():
	will_jump = true


func _physics_process(delta):
	
	var movement_y = velocity.y
	var movement_xz = velocity
	movement_xz.y = 0

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
	
	if will_jump and is_on_floor():
		movement_y += 10
		movement_xz += current_direction * boost
		will_jump = false


	

	# Ground Velocity
	movement_xz = movement_xz.limit_length(max_speed)

	# Vertical Velocity
	if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
		movement_y = movement_y - (fall_acceleration * delta)


	if not is_on_floor():
		$Pivot/Camera3D.rotation_degrees = Vector3(clamp(movement_y * 2.5 + camera_angle + 1, -90, camera_angle), 0, 0)
	else:
		$Pivot/Camera3D.rotation_degrees = Vector3(clamp($Pivot/Camera3D.rotation_degrees[0] + 1, -90, camera_angle), 0, 0)

	
	velocity = movement_xz
	velocity.y  = movement_y
	print(velocity)
	# Moving the Character
	move_and_slide()

		

func _on_bounce_body_entered(body: Node3D) -> void:
	if body.has_method("jump"):
		body.jump()
