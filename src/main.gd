extends Node


func _on_player_destroyed() -> void:
	Globals.current_score = $Highscore.current_highscore
	$Scoreboard.show()
	$Player.process_mode = Node.PROCESS_MODE_DISABLED
