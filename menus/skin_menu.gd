extends Control

var stats = Stats

@onready var sprite = $CenterContainer/HBoxContainer/textures/sprite
@onready var color_picker_button = $ColorPickerButton
@onready var transition = $transition

func _ready():
	sprite.modulate = stats.runner_color
	color_picker_button.color = stats.runner_color

func _on_color_picker_button_color_changed(color):
	stats.runner_color = Color(color)
	sprite.modulate = Color(color)

func _on_back_button_pressed():
	SaveAndLoad.update_save_data()
	transition.fade_out()
	await get_tree().create_timer(stats.transition_time).timeout
	get_tree().change_scene_to_file("res://menus/main_menu.tscn")

