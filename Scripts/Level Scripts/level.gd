extends Node2D

@onready var hole_controller = $HoleController
@onready var player = $Player
@onready var water_fill = $UI/Control/WaterFill
@onready var depth_label = $UI/Depth/DepthLabel

var depth := 0.

# Called when the node enters the scene tree for the first time.
func _ready():
	#setup the controller for spawning the holes
	hole_controller.setupController(50, 950, 140, 160)
	player.delete_hole.connect(onHoleDeleted)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var net_water_level = hole_controller.getNetWaterLevel()
	water_fill.set_value(water_fill.value + net_water_level)
	depth += delta
	
	depth_label.text = "Depth: -" + str(int(depth)) + " m"

func onHoleDeleted(hole: Hole):
	hole_controller.destroyHole(hole)
