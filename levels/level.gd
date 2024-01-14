extends Node2D
class_name Level

var stats = Stats
var sounds = Sounds

var current_run = {
	"positions":[],
	"color":Color.WHITE,
}
var ghost_frame = 1

var ghost_run
var ghost_run_finished = false
@onready var ghost = $ghost

var other_ghost_on = false
var other_ghost_run
var other_ghost_run_finished = false
@onready var other_ghost = $other_ghost

@export var level_music = "music_original"
@export var level_name = "Level Temp"
@export var level_id = "level_0_0"

var level_id_board
var time_string

var record_time
var pausable= true
var resetting = false

@onready var tile_map = $TileMap
@onready var player = $player
@onready var timer = $ui/timer
@onready var ui = $ui
@onready var pause_menu = $ui/pause_menu
@onready var level_finish_menu = $ui/level_finish_menu
@onready var finish = $finish
@onready var lasers = $lasers

var run_start = false

func _ready():
	get_tree().paused = false
	set_current_run_textures()
	set_other_ghost()
	ghost_run = stats.save_data[level_id]["ghost"]
	if ghost_run["positions"].size() == 0:
		ghost.visible = false
	else:
		ghost.position = player.position
	level_set_up()
	SaveAndLoad.update_save_data()
	sounds.play_music(level_music)
	player.connect("start_level",start_level)
	pause_menu.connect("resetting",disable_go)
	ui.enter_transition()
	pause_menu.set_up_leaderboards(stats.save_data[level_id][time_string], level_name, level_id, level_id_board)
	for laser in lasers.get_children():
		laser.connect("player_dead",player_dead)

func player_dead():
	reset_scene()

func set_current_run_textures():
	current_run.color = stats.save_data["runner_color"]

func set_other_ghost():
	if stats.save_data[level_id]["other_ghost"]["positions"].size()>0:
		other_ghost_on = true
		other_ghost_run = stats.save_data[level_id]["other_ghost"]
		other_ghost.position = player.position
		other_ghost.modulate = Color("ff563f1e")
		if "name_and_time" in other_ghost_run:
			ui.ghost_label.text = "Online Ghost - "+other_ghost_run.name_and_time
			pass
		else:
			ui.ghost_label.text = "Online Ghost - No Name Saved"
	else:
		other_ghost.visible = false
		ui.ghost_label.text = "Online Ghost - N/A"

func _input(event):
	if event.is_action_pressed("pause"):
		if pausable:
			pause_menu.pause()
		pausable = !pausable
	if event.is_action_pressed("reset_level"):
		reset_scene()

func reset_scene():
	disable_go()
	ui.exit_transition()
	get_tree().paused = true
	await get_tree().create_timer(stats.transition_time).timeout
	get_tree().reload_current_scene()

func disable_go():
	resetting  = true

func level_set_up():
	level_id_board = level_id
	time_string = "time"
	level_name = level_name
#	Set UI Level Label
	ui.level_label.text = level_name

@warning_ignore("unused_parameter")
func _physics_process(delta):
	if run_start == true:
		catch_ghost()
		if ghost_frame >= ghost_run["positions"].size():
			ghost_run_finished = true
		if ghost_run_finished == false:
			play_ghost()
		if other_ghost_on:
			if ghost_frame >= other_ghost_run["positions"].size():
				other_ghost_run_finished = true
			if other_ghost_run_finished == false:
				play_other_ghost()
		ghost_frame+=1

func catch_ghost():
	current_run["positions"].push_back(player.position)

func play_ghost():
	ghost.position = ghost_run["positions"][ghost_frame]

func play_other_ghost():
	var ghost_position = "Vector2"+(other_ghost_run["positions"][ghost_frame])
	other_ghost.position = str_to_var(ghost_position)

func start_level():
	if !resetting:
		run_start = true
		@warning_ignore("narrowing_conversion")
		sounds.play_sfx("go",randf_range(1.2,1.5),10)
		start_timer()

func start_timer():
	timer.timer_on = true

func update_score():
	var new_best = false
	if SilentWolf.Auth.logged_in_player != null:
		current_run["name_and_time"] = SilentWolf.Auth.logged_in_player+": "+"%02d:%02d:%03d" % [fmod(timer.time, 60*60)/60, fmod(timer.time,60), fmod(timer.time, 1)*1000]
		var meta_data = current_run
		SilentWolf.Scores.save_score(SilentWolf.Auth.logged_in_player, timer.time*-1, level_id_board, meta_data)
	if timer.time < stats.save_data[level_id][time_string]:
		stats.save_data[level_id][time_string] = timer.time
		stats.save_data[level_id]["ghost"] = current_run
		new_best = true
	record_time = stats.save_data[level_id][time_string]
	return new_best

func _on_finish_level_complete():
	pausable = false
	timer.timer_on = false
	@warning_ignore("narrowing_conversion")
	sounds.play_sfx("clapping",randf_range(.9,1.2), -5)
	var new_best = update_score()
	SaveAndLoad.update_save_data()
	ui.level_finished(record_time, level_name, level_id, new_best)
	await get_tree().create_timer(2).timeout
	level_finish_menu.load_scores(level_id_board)
