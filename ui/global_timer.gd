extends Control

var global_timer = GlobalTimer

@onready var label = $Label

func _ready():
	global_timer.connect("time_change", update_timer)

func update_timer(time):
	label.text = time
