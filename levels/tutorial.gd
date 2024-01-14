extends Node2D

var stats = Stats
var sounds = Sounds

@export var level_music = "menu"


@onready var tile_map = $TileMap
@onready var player = $player
@onready var finish = $finish
@onready var lasers = $lasers
@onready var animation_player = $ui/AnimationPlayer
@onready var checkpoint = $checkpoint
@onready var pause_menu = $ui/pause_menu
@onready var keyboard_controls = $keyboard_controls
@onready var controller_controls = $controller_controls


var login_board = "res://addons/silent_wolf/Auth/Login.tscn"
var menu_board = "res://menus/main_menu.tscn"
var run_start = false
var pausable= true
var resetting = false

func _ready():
	RenderingServer.set_default_clear_color(Color.BLACK)
	get_tree().paused = false
	animation_player.play("fade_in")
	sounds.play_music(level_music)
	player.connect("start_level",start_level)
	for laser in lasers.get_children():
		laser.connect("player_dead",player_dead)

func _input(event):
	if event is InputEventJoypadButton || event is InputEventJoypadMotion:
		keyboard_controls.hide()
		controller_controls.show()
	elif event is InputEventKey || event is InputEventMouseButton:
		keyboard_controls.show()
		controller_controls.hide()
	if event.is_action_pressed("pause"):
		if pausable:
			pause_menu.pause()
		pausable = !pausable
	if event.is_action_pressed("reset_level"):
		reset_scene()

func player_dead():
	player.velocity = Vector2.ZERO
	player.position = checkpoint.position

func reset_scene():
	animation_player.play("fade_out")
	get_tree().paused = true
	await get_tree().create_timer(stats.transition_time).timeout
	get_tree().reload_current_scene()

func start_level():
	run_start = true
	@warning_ignore("narrowing_conversion")
	sounds.play_sfx("go",randf_range(1.2,1.5),10)

func _on_finish_level_complete():
	@warning_ignore("narrowing_conversion")
	sounds.play_sfx("clapping",randf_range(.9,1.2), -5)
	stats.save_data["tutorial_complete"] = true
	SaveAndLoad.update_save_data()
	animation_player.play("fade_out")
	await get_tree().create_timer(2).timeout
	if SilentWolf.Auth.logged_in_player == null:
		get_tree().change_scene_to_file(login_board)
	else:
		get_tree().change_scene_to_file(menu_board)

func _on_dash_area_body_entered(body):
	player.has_dash = true
	player.dash_sprite.visible = true

func _on_slide_area_body_entered(body):
	player.has_slide = true

func _on_volume_button_pressed():
	#get_tree().paused = true
	player.set_physics_process(false)
	$ui/volume_menu.show()

func _on_volume_menu_hide_menu():
	#get_tree().paused = false
	await get_tree().create_timer(stats.transition_time).timeout
	player.set_physics_process(true)
