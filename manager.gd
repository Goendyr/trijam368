extends Node

var start_baby
var is_game_started = false
var player: Node3D
var cam
var game_audiostream: AudioStreamPlayer
var menu_audiostream: AudioStreamPlayer
var title
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	title = $"../PlayerCamera/Title"
	game_audiostream = $"../game_audio"
	menu_audiostream = $"../menu_audio"
	cam = $"../PlayerCamera"
	player = $"../Player"
	player.process_mode = Node.PROCESS_MODE_DISABLED
	cam.process_mode = Node.PROCESS_MODE_DISABLED
	# TODO change start_baby to select the nearest baby to support restart
	var start_baby_scene = preload("res://baby.tscn")
	start_baby = start_baby_scene.instantiate()
	get_tree().root.add_child.call_deferred(start_baby)
	title.visible = true
	#player = $"../FordFocusMesh"
	#TODO disable following

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not is_game_started && not player._allow_control:
		player.position = start_baby.position
		player.position.y = 80
		cam.position = start_baby.position + Vector3(0,1,2)
	elif is_game_started && not player._allow_control:
		player.position.x = start_baby.position.x
		player.position.z = start_baby.position.z
	if(Input.is_action_just_pressed("start_game") && !is_game_started):
		is_game_started = true
		player.process_mode = Node.PROCESS_MODE_ALWAYS
		
		# music change
		# TODO fade
		game_audiostream.play()
		menu_audiostream.stop()
		
		# titel change
		title.show_ford()
			
	if player._allow_control:
		cam.process_mode = Node.PROCESS_MODE_ALWAYS
		title.visible = false
