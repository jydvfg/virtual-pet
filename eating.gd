extends State

class_name EatingState

@export var pet_sprite: AnimatedSprite2D

@onready var sound = $EatSound

func Enter():
	pet_sprite.play("eating")
	sound.play()
	
	await get_tree().create_timer(3.0).timeout
	
	transitioned.emit(self, "idlestate")
