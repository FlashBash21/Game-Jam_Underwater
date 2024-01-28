extends Node2D

@onready var parallax_background = $ParallaxBackground


func _process(delta):
	parallax_background.scroll_base_offset -= Vector2(0, 100) * delta
