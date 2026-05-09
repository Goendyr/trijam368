extends Camera3D

var start_baby: Node3D
var is_game_started = false
var player: Node3D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# TODO change start_baby to select the nearest baby to support restart
	start_baby = $"../start_baby"
	player = $"../FordFocusMesh"
	player.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(not is_game_started):
		position = start_baby.position + Vector3(0,1,-2)
	if(Input.is_action_just_pressed("start_game") && !is_game_started):
		is_game_started = true
		# spawn car
		# cam zoom out on baby hit
