extends Control

var stats = Stats
var save_and_load = SaveAndLoad

var tutorial_scene = "res://levels/tutorial.tscn"
var credits_scene = "res://menus/credits.tscn"

@onready var back_button = $back_button
@onready var volume_menu = $volume_menu
@onready var keybinding_menu = $keybinding_menu

func _on_back_button_pressed():
	hide()

func _on_sounds_button_pressed():
	volume_menu.show()
	volume_menu.master_slider.grab_focus()

func _on_keybindings_button_pressed():
	keybinding_menu.show()
	keybinding_menu.left.grab_focus()

func _on_volume_menu_hide_menu():
	back_button.grab_focus()

func _on_keybinding_menu_hide_menu():
	back_button.grab_focus()

func _on_tutorial_button_pressed():
	get_tree().change_scene_to_file(tutorial_scene)

func _on_credits_button_pressed():
	get_tree().change_scene_to_file(credits_scene)
