extends Control

@onready var texture_progress_bar = $TextureProgressBar

func setValue(value:float) -> void:
	texture_progress_bar.value = value
	
func reset() -> void:
	texture_progress_bar.value = 0
