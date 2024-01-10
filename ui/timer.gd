extends Control

var stats = Stats

@onready var label = $Label

var time = 0
var timer_on = false

func _physics_process(delta):
	if timer_on:
		time += delta
	
	var mils = fmod(time, 1)*1000
	var secs = fmod(time,60)
	var mins = fmod(time, 60*60)/60
	
	var time_passed = "%02d:%02d:%03d" % [mins,secs,mils]
	label.text = time_passed

