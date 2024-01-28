extends Control

@onready var audio_stream_player = $AudioStreamPlayer
@onready var click_player = $ClickPlayer

func _ready():
	audio_stream_player.play(GlobVars.musicProgress)
	click()

func click():
	click_player.play()

func _on_back_button_pressed():
	GlobVars.musicProgress = audio_stream_player.get_playback_position()
	get_tree().change_scene_to_file("res://Scenes/Systems/start_menu.tscn")


func _on_audio_stream_player_finished():
	audio_stream_player.play()
