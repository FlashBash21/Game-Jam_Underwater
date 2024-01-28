extends Node2D

@onready var hole_controller = $HoleController
@onready var player = $Player
@onready var depth_label = $UI/Depth/DepthLabel
@onready var drain_button = $DrainButton
@onready var harpoon_button = $HarpoonButton
@onready var intro_song_player = $IntroSongPlayer
@onready var loop_song_player = $LoopSongPlayer
@onready var submersable = $Submersable
@onready var difficulty_timer = $"Difficulty Timer"

var save_path = "user://SubSinkers.save"

var depth := 0.
var water_level := 0.

var difficulty_level := 1

# Called when the node enters the scene tree for the first time.
func _ready():
	#setup the controller for spawning the holes
	hole_controller.setupController(50, 880, 120, 160)
	player.delete_hole.connect(onHoleDeleted)
	player.drain_water.connect(onDrainWater)
	intro_song_player.play()
	difficulty_timer.start()
	hole_controller.updateSpawnTimer(getNewTime())
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	var net_water_level = hole_controller.getNetWaterGain() * delta * getWaterMulti()
	net_water_level -= hole_controller.getNetWaterLoss() * delta
	water_level += net_water_level
	water_level = max(water_level, 0)
	var sub_texture = submersable.get_node("WaterFill") as TextureProgressBar
	sub_texture.set_value(water_level)
	if water_level >= 100:
		save_high_score()
		get_tree().change_scene_to_file("res://Scenes/Systems/lose_menu.tscn")
	depth += delta / 2
	
	depth_label.text = "Depth: -" + str(int(depth)) + " m"

func onHoleDeleted(hole: Hole):
	hole_controller.destroyHole(hole)

func onDrainWater():
	hole_controller.beginDraining()
	drain_button.primeVisualCooldown(hole_controller.getDrainCooldown())
	harpoon_button.primeVisualCooldown(hole_controller.getDrainCooldown())

func getWaterMulti() -> float:
	return 1*log(5 + difficulty_level)

func getNewTime() -> float:
	return max(4-.75 * log(2+difficulty_level), 1.75)	

func _on_intro_song_player_finished():
	loop_song_player.play()


func _on_loop_song_player_finished():
	loop_song_player.play()


func _on_difficulty_timer_timeout():
	difficulty_level += 1
	var new_time = getNewTime()
	hole_controller.updateSpawnTimer(new_time)
	print("Difficulty Increased! Timer at: " + str(new_time))
	print("Water Multiplier: " + str(getWaterMulti()))

func save_high_score():
	var file
	var old_score = 0
	if FileAccess.file_exists(save_path):
		file = FileAccess.open(save_path, FileAccess.READ)
		old_score = file.get_var()
		file.close()
	file = FileAccess.open(save_path, FileAccess.WRITE)
	print(depth)
	print(old_score)
	file.store_var(max(depth, old_score))
