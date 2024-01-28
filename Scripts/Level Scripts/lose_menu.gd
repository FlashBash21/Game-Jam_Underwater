extends Control
@onready var audio_stream_player = $AudioStreamPlayer

func _ready():
	audio_stream_player.play()


func _on_menu_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Systems/start_menu.tscn")


func _on_restart_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Entities/level.tscn")


func _on_quit_button_pressed():
	get_tree().quit()
