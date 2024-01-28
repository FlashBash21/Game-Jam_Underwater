extends Control

@onready var audio_stream_player = $AudioStreamPlayer
@onready var bobbing_animation = $BobbingAnimation

func _ready():
	bobbing_animation.play("float")

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Entities/level.tscn")


func _on_quit_button_pressed():
	get_tree().quit()


func _on_audio_stream_player_finished():
	audio_stream_player.play()
