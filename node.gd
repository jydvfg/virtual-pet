extends Node
var current_state : State

@export var initial_state : State

var states : Dictionary = {}

func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.transitioned.connect(on_child_transition)
			
	if initial_state:
		initial_state.Enter()
		current_state = initial_state


func _process(delta: float) -> void:
	if current_state:
		current_state.Update(delta)

func on_child_transition(state, new_state_name):
	print("transitioning")
	if state !=current_state:
		return
	
	var new_state = states.get(new_state_name.to_lower())
	print(new_state)
	if !new_state:
		return
	
	if current_state:
		current_state.Exit()
		
	new_state.Enter()
	current_state = new_state


func _on_feed_pressed() -> void:
	print("clickclick")
	on_child_transition(current_state, "eatingstate")

func _on_dance_pressed() -> void:
	print("dancedance")
	on_child_transition(current_state, "dancingstate")
