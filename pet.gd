extends Node2D

@onready var pet = $character
@onready var state_machine = $character/StateMachine
@onready var pet_stats =  $PetStats
@onready var pause_button = $Pauseu
@onready var pause_menu = $PauseOverlay

@export var PORT: int = 9999
var server = TCPServer.new()
var active_connections: Array[StreamPeerTCP] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	RenderingServer.set_default_clear_color(Color.BLACK)
	if server.listen(PORT) == OK:
		print("Listening on port: ", PORT)
	else:
		print("Failed to start server")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if server.is_connection_available():
		var new_connection = server.take_connection()
		active_connections.append(new_connection)
		
	for i in range(active_connections.size() - 1, -1, -1):
		var connection = active_connections[i]
		if connection.get_status() != StreamPeerTCP.STATUS_CONNECTED:
			active_connections.remove_at(i)
			continue
		var bytes = connection.get_available_bytes()
		if bytes > 0:
			var new_string = connection.get_utf8_string(bytes)
			parse_voice_command(new_string)
		
func parse_voice_command(string: String):
	var clean_string = string.to_lower().strip_edges()
	if "feed" in clean_string and "healthy" in clean_string:
		pet_stats.eat_tally +=1
		state_machine.on_child_transition(state_machine.current_state, "eatingstate")
	elif "feed" in clean_string:
		state_machine.on_child_transition(state_machine.current_state, "eatingstate") 
	elif "workout" in clean_string:
		pet_stats.fitness_score +=1
		state_machine.on_child_transition(state_machine.current_state, "dancingstate")
	elif "study" in clean_string:
		pet_stats.study_score +=1
		state_machine.on_child_transition(state_machine.current_state, "dancingstate")
	elif "meds" in clean_string:
		pet_stats.med_tally +=1
		state_machine.on_child_transition(state_machine.current_state, "eatingstate")

		


func _on_pause_pressed() -> void:
	get_tree().paused = true
	pause_menu.show()


func _on_play_pressed() -> void:
	get_tree().paused = false
	pause_menu.hide()
