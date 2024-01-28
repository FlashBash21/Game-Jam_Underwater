extends Interactable
class_name Hole

@onready var sprite = $AnimatedSprite2D
@onready var gpu_particles_2d = $GPUParticles2D
@onready var pop_player = $PopPlayer


func _ready():
	sprite.play("default")
	gpu_particles_2d.emitting = true
	pop_player.play()
func select():
	sprite.play("highlight")

func deselect():
	sprite.play("default")
