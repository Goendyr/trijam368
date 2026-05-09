extends CanvasLayer


@onready var rich_text_label: RichTextLabel = %RichTextLabel
@onready var line_edit: LineEdit = %LineEdit


func _on_name_button_pressed() -> void:
	if line_edit.text.is_empty():
		return
	
	$NameEntry.hide()
	var idx: int = -1
	for i: int in Globals.highscores.size():
		if Globals.highscores[i][0] == line_edit.text:
			idx = i
	
	if idx == -1:
		Globals.highscores.append([line_edit.text, Globals.current_score])
	elif Globals.highscores[idx][1] < Globals.current_score:
		Globals.highscores[idx][1] = Globals.current_score

	
	Globals.highscores.sort_custom(func(a, b): return a[1] > b[1])
	print(Globals.highscores)
	
	var highscore_string: String = "[fill]"
	for elem in Globals.highscores:
		highscore_string += elem[0] + " " + str(elem[1]) + "[br]"
	highscore_string += "[/fill]\n"
	
	rich_text_label.text = highscore_string
	$ScoreList.show()


func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_line_edit_text_submitted(_new_text: String) -> void:
	_on_name_button_pressed()
