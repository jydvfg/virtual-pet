extends State

class_name DancingState
@export var pet_sprite : AnimatedSprite2D
@onready var dancing_timer = $Timer

func Enter():
	pet_sprite.play("dancing")
	dancing_timer.start()



func _on_timer_timeout() -> void:
	transitioned.emit(self, "idlestate")
	dancing_timer.stop()
