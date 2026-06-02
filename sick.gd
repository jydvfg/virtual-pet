extends State
class_name SickState

@export var pet_sprite :AnimatedSprite2D
@onready var sick_sound = $SickSound

func Enter():
	sick_sound.play()
	pet_sprite.play("sick")
