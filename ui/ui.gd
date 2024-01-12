extends CanvasLayer

var stats = Stats

@onready var level_finish_menu = $level_finish_menu
@onready var timer = $timer
@onready var pause_menu = $pause_menu
@onready var level_label = $level_label
@onready var ghost_label = $ghost_label
@onready var pop_up_label = $pop_up_label

@onready var transition = $transition
@onready var animation_player = $AnimationPlayer

func enter_transition():
	animation_player.play("fade_in")

func exit_transition():
	animation_player.play("fade_out")

func _ready():
	transition.visible = true
	pop_up_label.text = ""

func level_finished(record_time, level_name, level_id, new_best):
	pause_menu.pausable = false
	level_finish_menu.change_pause()
	level_finish_menu.update_times(timer.time, record_time, level_name, level_id, new_best)

func pop_up(type,text):
	if type == "egg":
		pop_up_label.text = "* New %s Unlocked *" %[text]
	elif type == "bone":
		pop_up_label.text = "* %s Discovered *" %[text]
	elif type == "message":
		pop_up_label.text = "! %s !" %[text]
	await get_tree().create_timer(2).timeout
	pop_up_label.text = ""

func _on_pause_menu_fade_out():
	exit_transition()

func _on_level_finish_menu_fade_out():
	exit_transition()

func _on_pause_menu_on_pause(paused):
	if timer.time != 0:
		timer.timer_on = !paused
