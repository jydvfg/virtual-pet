extends State

class_name SleepingState

@onready var wake_timer = $Timer
@onready var pet_sprite = $"../.."

signal wake_signal

func Enter():
	pet_sprite.play("sleeping")


func _on_idle_state_sleep_signal() -> void:
	wake_timer.start()
	print("fire")
	transitioned.emit(self, "sleepingstate")
	Enter()
	

func _on_timer_timeout() -> void:
	wake_timer.stop()
	wake_signal.emit()
