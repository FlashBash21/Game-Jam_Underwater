extends Area2D
class_name Hole

@onready var highlight = $Highlight

func _ready():
	highlight.visible = false

func select():
	highlight.visible = true

func deselect():
	highlight.visible = false
