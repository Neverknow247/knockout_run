extends Control

var stats = Stats
var sounds = Sounds

var tutorial_scene = "res://levels/tutorial.tscn"
var leaderboards_scene = "res://menus/leaderboards/leaderboard.tscn"

@onready var start_button = $CenterContainer/HBoxContainer/VBoxContainer/start_button
@onready var logged_in_user = $logged_in_user
@onready var login = $VBoxContainer2/login
@onready var logout = $VBoxContainer2/logout
@onready var credits_button = $CenterContainer/HBoxContainer/VBoxContainer/credits_button
@onready var transition = $transition
@onready var color_picker_button = $change_color/CenterContainer/ColorPickerButton
@onready var settings_menu = $settings_menu
@onready var background = $background

func _ready():
	SaveAndLoad.update_save_data()
	set_log_buttons()
	if SilentWolf.Auth.logged_in_player != null:
		logged_in_user.text = "Logged in User: "+SilentWolf.Auth.logged_in_player
		logged_in_user.add_theme_color_override("font_color",Color("#66cdaa"))
		SaveAndLoad.change_save_location()
		SaveAndLoad.load_data()
		stats.save_data["tutorial_complete"] = true
		SaveAndLoad.update_save_data()
	sounds.play_music("menu")
	start_button.grab_focus()
	color_picker_button.color = stats.save_data["runner_color"]

func set_log_buttons():
	if SilentWolf.Auth.logged_in_player != null:
		login.visible = false
		logout.visible = true
	else:
		login.visible = true
		logout.visible = false

func _on_start_button_pressed():
	transition.fade_out()
	await get_tree().create_timer(stats.transition_time).timeout
	get_tree().change_scene_to_file("res://levels/levels_1/level_1_1.tscn")

func _on_quit_button_pressed():
	transition.fade_out()
	await get_tree().create_timer(stats.transition_time).timeout
	get_tree().quit()

func _on_login_pressed():
	transition.fade_out()
	await get_tree().create_timer(stats.transition_time).timeout
	get_tree().change_scene_to_file("res://addons/silent_wolf/Auth/Login.tscn")

func _on_logout_pressed():
	login.visible = true
	logout.visible = false
	SilentWolf.Auth.logout_player()
	logged_in_user.text = "Logged Out"
	logged_in_user.add_theme_color_override("font_color",Color("#fb6c6c"))
	SaveAndLoad.change_save_location()
	SaveAndLoad.load_data()

func _on_credits_pressed():
	transition.fade_out()
	await get_tree().create_timer(stats.transition_time).timeout
	get_tree().change_scene_to_file("res://menus/credits.tscn")

func _on_dog_house_button_pressed():
	transition.fade_out()
	await get_tree().create_timer(stats.transition_time).timeout
	get_tree().change_scene_to_file("res://menus/skin_menu.tscn")

func _on_volume_menu_hide_menu():
	transition.fade_out()
	await get_tree().create_timer(stats.transition_time).timeout
	transition.fade_in()
	start_button.grab_focus()

func _on_leaderboard_button_pressed():
	get_tree().change_scene_to_file(leaderboards_scene)

func _on_color_picker_button_color_changed(color):
	stats.save_data["runner_color"] = Color(color)

func _on_tutorial_button_pressed():
	get_tree().change_scene_to_file(tutorial_scene)

func _on_settings_button_pressed():
	settings_menu.show()
	$settings_menu/CenterContainer/VBoxContainer/sounds_button.grab_focus()

func _on_settings_menu_hide_menu():
	$CenterContainer/HBoxContainer/VBoxContainer/settings_button.grab_focus()
