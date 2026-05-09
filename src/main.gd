extends Node


func _on_player_destroyed() -> void:
	Globals.current_score = $Highscore.current_highscore
	$Scoreboard.show()
	get_tree().paused = true
