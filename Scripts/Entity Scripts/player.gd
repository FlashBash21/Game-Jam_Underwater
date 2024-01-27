extends CharacterBody2D

signal delete_hole(hole)
@onready var interaction_area = $"Interaction Area"
@onready var progress_circle = $ProgressCircle

const SPEED = 600.0
const JUMP_VELOCITY = -400.0
const USE_TIME = 1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var nearest_hole: Hole
var interaction_timer: float

func _ready() -> void:
	progress_circle.visible = false
	progress_circle.reset()

func _physics_process(delta: float) -> void:
	
	#check if we are still in range of our nearest hole
	var new_hole = getHoleInRange()
	if new_hole != nearest_hole: resetTimer()
	
	nearest_hole = new_hole
	

	handleInteraction(delta)
	if nearest_hole and interaction_timer <= 0:
		delete_hole.emit(nearest_hole)
		resetTimer()

	modifyVelocity(delta)
	move_and_slide()

func handleInteraction(delta: float) -> void:
	if Input.is_action_pressed("Interaction") and nearest_hole:
		interaction_timer -= delta
		progress_circle.setValue(100 - (interaction_timer/USE_TIME*100))
		progress_circle.visible = true
	else:
		resetTimer()
		progress_circle.reset()
		progress_circle.visible = false

func resetTimer() -> void:
	interaction_timer = USE_TIME

#adjusts velocity property based on delta
func modifyVelocity(delta: float) -> void:
		# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
#returns a hole in range with no particular ordering, prioritising the currently selected hole
#selects the hole for you
#null if no hole in range
func getHoleInRange() -> Hole:
	#make sure the nearest hole is still in range
	if nearest_hole:
		if interaction_area.overlaps_area(nearest_hole):
			selectHole(nearest_hole)
			return nearest_hole
	
	#find some other hole in range
	var in_range_holes = interaction_area.get_overlapping_areas()
	if in_range_holes.size() > 0:
		var chosen_hole = in_range_holes[0] as Hole
		selectHole(chosen_hole)
		return chosen_hole
	selectHole(null)
	return null

#highlights the nearest hole and unhighlights the others
func selectHole(hole: Hole) -> void:
	if nearest_hole:
		nearest_hole.deselect()
	nearest_hole = hole
	if nearest_hole:
		nearest_hole.select()
		
