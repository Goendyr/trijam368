extends Camera3D

var _target_pos = Vector3()

var _target_direction = Vector3()

var _target

@export var distance = 4

@export var radius = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(radius > distance)
	_target = get_node("../Player")
	# Turn off automatic physics interpolation for the Camera,
	# we will be doing this manually
	set_physics_interpolation_mode(Node.PHYSICS_INTERPOLATION_MODE_OFF)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Find the current interpolated transform of the target
	var tr : Transform3D = _target.get_global_transform_interpolated()
	
	# Provide some delayed smoothed lerping towards the target position
	_target_pos = lerp(_target_pos, tr.origin, delta * 10)
	_target_direction = lerp(_target_direction, _target.current_direction, delta * 10)
	

	position =  _target_pos - _target_direction * distance + Vector3.UP * sqrt( radius**2 - distance**2 )

	# Fixed camera position, but it will follow the target
	look_at(_target_pos, Vector3(0, 1, 0))
