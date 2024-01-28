extends Control
@onready var audio_stream_player = $AudioStreamPlayer
@onready var click_player = $AudioStreamPlayer2
@onready var score_label = $MarginContainer3/ScoreLabel
var save_path = "user://SubSinkers.save"

func _ready():
	audio_stream_player.play()
	load_high_score()

func click():
	click_player.play()

func _on_menu_button_pressed():
	click()
	get_tree().change_scene_to_file("res://Scenes/Systems/start_menu.tscn")


func _on_restart_button_pressed():
	click()
	get_tree().change_scene_to_file("res://Scenes/Entities/level.tscn")


func _on_quit_button_pressed():
	click()
	get_tree().quit()

func load_high_score():
	var score = 0
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		score = int(file.get_var())
		score_label.text = "High Score: -" + str(score) + "m"

	else:
		score_label.text = "High Score: -0m"
		
