extends Node2D

@onready var hole_controller = $HoleController
@onready var player = $Player


# Called when the node enters the scene tree for the first time.
func _ready():
	#setup the controller for spawning the holes
	hole_controller.setupController(50, 500, 140, 160)
	player.delete_hole.connect(onHoleDeleted)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func onHoleDeleted(hole: Hole):
	hole_controller.destroyHole(hole)
