extends TextureRect

var stats = Stats
var sounds = Sounds
var utils = Utils

@onready var transition = $transition
@onready var timer = $Timer
@onready var easter_egg_button = $easter_egg_button

var easter_egg_audio = "angel_1_1"
var tutorial_board = "res://levels/tutorial.tscn"
var login_board = "res://addons/silent_wolf/Auth/Login.tscn"
var menu_board = "res://menus/main_menu.tscn"

func _ready():
	#reset_leaderboards()
	RenderingServer.set_default_clear_color(Color.BLACK)
	SilentWolf.Auth.auto_login_player()
	sounds.play_sfx("smell_this_bread",1,-10)
	await get_tree().create_timer(2).timeout
	start()

func start():
	timer.start()
	SaveAndLoad.change_save_location()
	SaveAndLoad.load_data()
	SaveAndLoad.load_settings()
	utils.set_volume()
	stats.save_data["power_on_count"] += 1
	SaveAndLoad.save_all()

func _on_timer_timeout():
	transition.fade_out()
	await get_tree().create_timer(stats.transition_time).timeout
	if !stats.save_data["tutorial_complete"]:
		get_tree().change_scene_to_file(tutorial_board)
	elif SilentWolf.Auth.logged_in_player == null:
		get_tree().change_scene_to_file(login_board)
	else:
		get_tree().change_scene_to_file(menu_board)

func _on_easter_egg_button_pressed():
	easter_egg_button.disabled = true
	timer.stop()
	sounds.play_sfx(easter_egg_audio,1,-5)
	timer.start(sounds.sfx[easter_egg_audio].get_length())

#func reset_leaderboards():
	#SilentWolf.Scores.wipe_leaderboard("level_1_1")
	#SilentWolf.Scores.wipe_leaderboard("main")


