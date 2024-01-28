extends Interactable
class_name IButton

@onready var highlight = $highlight
@onready var progress_circle = $ProgressCircle
@onready var cooldown_timer = $CooldownTimer

func _ready():
	highlight.visible = false
	progress_circle.visible = false

func _process(delta):
	if !cooldown_timer.is_stopped():
		setVisualTimer((cooldown_timer.time_left / cooldown_timer.wait_time) * 100)
	else:
		progress_circle.visible = false

func select():
	highlight.visible = true

func deselect():
	highlight.visible = false

func primeVisualCooldown(value: float):
	if cooldown_timer.is_stopped():
		cooldown_timer.wait_time = value
		cooldown_timer.start()
		progress_circle.visible = true
		setVisualTimer(0)

func setVisualTimer(value: float):
	progress_circle.setValue(value)
