extends Node

@onready var drain_time = $DrainTime
@onready var drain_cooldown = $DrainCooldown
@onready var timer = $SpawnTimer
@onready var button_click_player = $ButtonClickPlayer

const Hole = preload("res://Scenes/Entities/hole.tscn")
var xRange: Vector2
var yRange: Vector2
var spawned_holes: Array

var draining := false

func getNetWaterGain() -> float:
	return spawned_holes.size()
	
func getNetWaterLoss() -> float:
	if draining: return 50 / drain_time.wait_time
	return 0
func playButtonClick() -> void:
	if !button_click_player.playing:
		button_click_player.play()

func beginDraining() -> void:
	if drain_cooldown.is_stopped():
		playButtonClick()
		draining = true
		drain_cooldown.start()
		drain_time.start()
	
# Call this when instantiating the controller
func setupController(minX, maxX, minY, maxY) -> void:
	xRange = Vector2(minX, maxX)
	yRange = Vector2(minY, maxY)
	timer.start()
	
func spawnHole() -> void:
	var new_hole = Hole.instantiate()
	new_hole.position = Vector2(randf_range(xRange.x, xRange.y), randf_range(yRange.x, yRange.y))
	add_child(new_hole)
	spawned_holes.append(new_hole)
	
func destroyHole(hole: Hole) -> void:
	spawned_holes.erase(hole)
	remove_child(hole)

func getDrainCooldown() -> float:
	return drain_cooldown.wait_time

func updateSpawnTimer(new_time: float) -> void:
	timer.wait_time = new_time

func _on_timer_timeout():
	spawnHole()
	timer.start()

func _on_drain_time_timeout():
	draining = false
