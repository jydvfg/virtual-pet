extends State

class_name DancingState
@export var pet_sprite : AnimatedSprite2D
@onready var dancing_timer = $Timer
@onready var dance_sound = $DanceSound

func Enter():
	pet_sprite.play("dancing")
	dance_sound.play()
	dancing_timer.start()



func _on_timer_timeout() -> void:
	transitioned.emit(self, "idlestate")
	dancing_timer.stop()
