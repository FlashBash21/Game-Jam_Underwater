extends CharacterBody2D

signal delete_hole(hole)
signal drain_water()

@onready var interaction_area = $"Interaction Area"
@onready var progress_circle = $ProgressCircle
@onready var sprite = $AnimatedSprite

@onready var walk_1_player = $Walk1Player
@onready var walk_2_player = $Walk2Player
@onready var repair_player = $RepairPlayer

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const USE_TIME = 1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var nearest_interactable: Interactable
var interaction_timer: float

func _ready() -> void:
	progress_circle.visible = false
	progress_circle.reset()

func _physics_process(delta: float) -> void:
	
	#check if we are still in range of our nearest interactable
	var new_interactable = getInteractableInRange()
	if new_interactable != nearest_interactable: resetTimer()
	
	nearest_interactable = new_interactable
	

	handleInteraction(delta)
	if nearest_interactable and interaction_timer <= 0:
		if nearest_interactable is Hole:
			delete_hole.emit(nearest_interactable)
		resetTimer()

	modifyVelocity(delta)
	move_and_slide()

func playWalkSounds() -> void:
	if !walk_1_player.playing and !walk_2_player.playing:
		if randi() % 2 == 1:
			walk_1_player.play()
		else:
			walk_2_player.play()

func playRepairSound() -> void:
	if !repair_player.playing:
		repair_player.play()

func handleInteraction(delta: float) -> void:
	if Input.is_action_pressed("Interaction") and nearest_interactable:
		if nearest_interactable is Hole:
			interaction_timer -= delta
			progress_circle.setValue(100 - (interaction_timer/USE_TIME*100))
			progress_circle.visible = true
			playRepairSound()
		if Input.is_action_just_pressed("Interaction") and nearest_interactable is IButton:
			drain_water.emit()
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


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		sprite.play("walk")
		playWalkSounds()
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		sprite.play("idle")
	
#returns a Interactable in range with no particular ordering, prioritising the currently selected Interactable
#selects the Interactable for you
#null if no Interactable in range
func getInteractableInRange() -> Interactable:
	#make sure the nearest interactable is still in range
	if nearest_interactable:
		if interaction_area.overlaps_area(nearest_interactable):
			selectInteractable(nearest_interactable)
			return nearest_interactable
	
	#find some other interactable in range
	var in_range_interactables = interaction_area.get_overlapping_areas()
	if in_range_interactables.size() > 0:
		var chosen_interactable = in_range_interactables[0] as Interactable
		selectInteractable(chosen_interactable)
		return chosen_interactable
	selectInteractable(null)
	return null

#highlights the nearest interactable and unhighlights the others
func selectInteractable(interactable: Interactable) -> void:
	if nearest_interactable:
		nearest_interactable.deselect()
	nearest_interactable = interactable
	if nearest_interactable:
		nearest_interactable.select()
		
