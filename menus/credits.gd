extends TextureRect

var stats = Stats

@onready var exit_button = $exit_button
@onready var transition = $transition

var first_time = false

func _ready():
	SaveAndLoad.update_save_data()

func mode_select():
	transition.fade_out_credits()
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://menus/main_menu.tscn")

func _on_exit_button_pressed():
	transition.fade_out()
	await get_tree().create_timer(stats.transition_time).timeout
	get_tree().change_scene_to_file("res://menus/main_menu.tscn")
