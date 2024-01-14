extends ColorRect

var stats = Stats

@onready var level_name = $VBoxContainer/level_name

@onready var resume_button = $buttons/resume_button
@onready var restart_button = $buttons/restart_button

@onready var volume_menu = $volume_menu

@onready var transition = $transition

signal fade_out
signal resetting
signal on_pause(paused)

var pausable = true
var mode

var paused = false:
	get:
		return paused
	set(value):
		paused = value
		on_pause.emit(paused)
		get_tree().paused = paused
		visible = paused
		

func _ready():
	visible = false

func _input(event):
	if event.is_action_pressed("pause") && paused:
		change_pause()
		volume_menu.visible = false
	if event.is_action_pressed("reset_level"):
		if paused:
			_on_restart_button_pressed()

func change_pause():
	self.paused = !paused
	if paused:
		restart_button.grab_focus()
	else:
		release_focus()

func pause():
	change_pause()

func _on_resume_button_pressed():
	change_pause()

func _on_restart_button_pressed():
	emit_signal("resetting")
	emit_signal("fade_out")
	await get_tree().create_timer(stats.transition_time).timeout
	if paused: change_pause()
	get_tree().reload_current_scene()

func _on_main_menu_button_pressed():
	emit_signal("fade_out")
	await get_tree().create_timer(stats.transition_time).timeout
	change_pause()
	get_tree().change_scene_to_file("res://menus/main_menu.tscn")

func _on_volume_button_pressed():
	transition.fade_out()
	await get_tree().create_timer(stats.transition_time).timeout
	volume_menu.visible = true
	transition.fade_in()

func _on_volume_menu_hide_menu():
	transition.fade_out()
	await get_tree().create_timer(stats.transition_time).timeout
	resume_button.grab_focus()
	transition.fade_in()
