extends State
class_name IdleState


@export var pet_sprite : AnimatedSprite2D
@onready var sleep_timer = $Timer
signal sleep_signal

func _ready() -> void:
	sleep_timer.start()


func Enter():
	if pet_sprite:
		pet_sprite.play("idle")


func _on_timer_timeout() -> void:
	var current_time = Time.get_time_string_from_system().substr(0,2).to_int()
	if current_time >= 21 or current_time <= 7:
		sleep_signal.emit()
		sleep_timer.stop()


func _on_sleeping_state_wake_signal() -> void:
	transitioned.emit(self, "idlestate")
	Enter()
	sleep_timer.start()


func _on_pet_stats_hungry() -> void:
	print("IdleState received hungry signal")
	transitioned.emit(self, "hungrystate")


func _on_pet_stats_sick() -> void:
	transitioned.emit(self, "sickstate")
