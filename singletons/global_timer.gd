extends Node

var time = 3599.9999
#var time = 0
var timer_on = false

signal time_change(time)

var time_passed:
	get:
		return time_passed
	set(value):
		time_passed = value
		emit_signal("time_change",time_passed)

func _ready():
#	timer_on = true
	pass

func _physics_process(delta):
	if timer_on:
		time += delta
	
	var mils = fmod(time, 1)*1000
	var secs = fmod(time,60)
	var mins = fmod(time, 60*60)/60
	var hours = fmod(fmod(time, 3600*60)/3600,24)
	
	time_passed = "%02d:%02d:%02d:%03d" % [hours,mins,secs,mils]
#	label.text = time_passed
