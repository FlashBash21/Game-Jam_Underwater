extends Node

@onready var timer = $Timer
const Hole = preload("res://Scenes/Entities/hole.tscn")
var xRange: Vector2
var yRange: Vector2
var spawned_holes: Array

func getNetWaterLevel() -> float:
	return spawned_holes.size() * (1./100.)

# Call this when instantiating the controller
func setupController(minX, maxX, minY, maxY):
	xRange = Vector2(minX, maxX)
	yRange = Vector2(minY, maxY)
	timer.start()
	
func spawnHole():
	var new_hole = Hole.instantiate()
	new_hole.position = Vector2(randf_range(xRange.x, xRange.y), randf_range(yRange.x, yRange.y))
	add_child(new_hole)
	spawned_holes.append(new_hole)
	
func destroyHole(hole: Hole):
	spawned_holes.erase(hole)
	remove_child(hole)

func _on_timer_timeout():
	spawnHole()
	timer.start()
