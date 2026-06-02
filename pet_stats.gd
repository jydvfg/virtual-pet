extends Node

signal hungry
signal sick

@onready var eat_tally = 0
@onready var med_tally = 0
@onready var food_score = 0
@onready var health_score = 0
@onready var fitness_score = 0
@onready var study_score = 0
@onready var days_past = 0
@onready var date_timer = $DateTimer
@onready var current_date = Time.get_date_dict_from_system()


func _ready() -> void:
	date_timer.start()


func _on_timer_timeout() -> void:
	var new_date = Time.get_date_dict_from_system()
	check_date(current_date, new_date)
	var current_time = Time.get_time_string_from_system().substr(0,2).to_int()
	if current_time >= 10 and med_tally == 0:
		sick.emit()
	if current_time >= 14 and current_time <= 15 and eat_tally <1 :
		hungry.emit()
	if current_time >= 20 and current_time <= 21 and eat_tally <2 :
		hungry.emit()
	
	
	
func check_date(date1, date2):
	var prev: int = date1.year * 10000  + date1.month * 100 + date1.day
	var new: int = date2.year * 10000 + date2.month * 100 + date2.day
	if new > prev:
		date1 = date2
		if med_tally == 1:
			health_score +=1 
			med_tally = 0
		if eat_tally == 2:
			food_score += 1
			eat_tally = 0
		days_past +=1 
		if days_past == 8:
			food_score = 0
			health_score = 0
			fitness_score = 0
			study_score = 0
			days_past = 0
				


func _on_feed_pressed() -> void:
	eat_tally += 1
	

func _on_meds_pressed() -> void:
	med_tally += 1

func _on_dance_pressed() -> void:
	fitness_score +=1 
