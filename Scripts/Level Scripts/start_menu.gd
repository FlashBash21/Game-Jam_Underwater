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

func click():
	click_player.play()

func _on_start_button_pressed():
	click()
	get_tree().change_scene_to_file("res://Scenes/Entities/level.tscn")


func _on_quit_button_pressed():
	click()
	get_tree().quit()


func _on_audio_stream_player_finished():
	audio_stream_player.play()


func _on_options_button_pressed():
	click()
	pass # Replace with function body.

func load_high_score():
	var score = 0
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		score = int(file.get_var())
		score_label.text = "High Score: -" + str(score) + "m"

	else:
		score_label.visible = false
		
