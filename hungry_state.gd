extends State
class_name HungryStae

@export var pet_sprite : AnimatedSprite2D
@onready var hungry_audio = $HungrySound


func Enter():
	pet_sprite.play("hungry")
	hungry_audio.play()
	

func _on_feed_pressed() -> void:
	transitioned.emit(self, "eatingstate")
