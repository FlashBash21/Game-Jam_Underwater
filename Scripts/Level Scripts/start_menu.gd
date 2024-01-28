extends Control

@onready var audio_stream_player = $AudioStreamPlayer
@onready var click_player = $ClickPlayer
@onready var bobbing_animation = $BobbingAnimation
@onready var score_label = $MarginContainer3/ScoreLabel
var save_path = "user://SubSinkers.save"

func _ready():
	bobbing_animation.play("float")
	score_label.visible = true
	load_high_score()
	audio_stream_player.play(GlobVars.musicProgress)
	if !GlobVars.launch:
		click()
	else:
		GlobVars.launch = false


func click():
	click_player.play()


func _on_start_button_pressed():
	GlobVars.musicProgress = audio_stream_player.get_playback_position()
	get_tree().change_scene_to_file("res://Scenes/Entities/level.tscn")


func _on_quit_button_pressed():
	get_tree().quit()


func _on_audio_stream_player_finished():
	audio_stream_player.play()


func _on_options_button_pressed():
	GlobVars.musicProgress = audio_stream_player.get_playback_position()
	get_tree().change_scene_to_file("res://Scenes/Systems/credits.tscn")

func load_high_score():
	var score = 0
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		score = int(file.get_var())
		score_label.text = "High Score: -" + str(score) + "m"

	else:
		score_label.visible = false
		


func _on_controls_pressed():
	click()
	GlobVars.musicProgress = audio_stream_player.get_playback_position()
	get_tree().change_scene_to_file("res://Scenes/Systems/controls.tscn")
