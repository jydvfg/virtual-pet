extends Label

@onready var timer = $Timer
func _ready() -> void:
	timer.start()
	

func _on_timer_timeout() -> void:
	self.text = Time.get_time_string_from_system()
