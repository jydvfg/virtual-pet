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
@onready var pet_sprite = $"../character"
@onready var baby_frames = preload("res://spriteframes/baby_sprite_frames.tres")
@onready var young_frames = preload("res://spriteframes/young_sprite_frames.tres")


func _ready() -> void:
	date_timer.start()


func _on_timer_timeout() -> void:
	var new_date = Time.get_date_dict_from_system()
	check_date(new_date)
	var current_time = Time.get_time_string_from_system().substr(0,2).to_int()
	if current_time >= 10 and med_tally == 0:
		sick.emit()
	if current_time >= 14 and current_time <= 15 and eat_tally <1 :
		hungry.emit()
	if current_time >= 20 and current_time <= 21 and eat_tally <2 :
		hungry.emit()
	
	
	
func check_date(new_date):
	var prev: int = current_date.year * 10000  + current_date.month * 100 + current_date.day
	var new: int = new_date.year * 10000 + new_date.month * 100 + new_date.day
	if new > prev:
		current_date = new_date
		if med_tally == 1:
			health_score +=1 
			med_tally = 0
		if eat_tally == 2:
			food_score += 1
			eat_tally = 0
		days_past +=1 
		if days_past == 8:
			pet_growth()
			food_score = 0
			health_score = 0
			fitness_score = 0
			study_score = 0
			days_past = 0
				

func pet_growth():
	var total_score = food_score + health_score + fitness_score + study_score
	if total_score > 18:
		if pet_sprite.sprite_frames == baby_frames:
			pet_sprite.sprite_frames = young_frames
	
			
func _on_meds_pressed() -> void:
	med_tally += 1

func _on_dance_pressed() -> void:
	fitness_score +=1 


func _on_feed_healthy_pressed() -> void:
	eat_tally += 1


func _on_study_pressed() -> void:
	study_score +=1
