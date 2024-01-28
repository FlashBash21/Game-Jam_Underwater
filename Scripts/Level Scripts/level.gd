extends Node2D

@onready var hole_controller = $HoleController
@onready var player = $Player
@onready var water_fill = $UI/Control/WaterFill
@onready var depth_label = $UI/Depth/DepthLabel
@onready var drain_button = $DrainButton
@onready var harpoon_button = $HarpoonButton
@onready var intro_song_player = $IntroSongPlayer
@onready var loop_song_player = $LoopSongPlayer

var depth := 0.

# Called when the node enters the scene tree for the first time.
func _ready():
	#setup the controller for spawning the holes
	hole_controller.setupController(50, 880, 120, 160)
	player.delete_hole.connect(onHoleDeleted)
	player.drain_water.connect(onDrainWater)
	intro_song_player.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var net_water_level = hole_controller.getNetWaterLevel(delta)
	water_fill.set_value(water_fill.value + net_water_level)
	if water_fill.value >= 100:
		get_tree().change_scene_to_file("res://Scenes/Systems/lose_menu.tscn")
	depth += delta / 2
	
	depth_label.text = "Depth: -" + str(int(depth)) + " m"

func onHoleDeleted(hole: Hole):
	hole_controller.destroyHole(hole)

func onDrainWater():
	hole_controller.beginDraining()
	drain_button.primeVisualCooldown(hole_controller.getDrainCooldown())
	harpoon_button.primeVisualCooldown(hole_controller.getDrainCooldown())


func _on_intro_song_player_finished():
	loop_song_player.play()


func _on_loop_song_player_finished():
	loop_song_player.play()
