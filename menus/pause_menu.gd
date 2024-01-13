extends ColorRect

var stats = Stats
var global_timer = GlobalTimer

const ScoreItem = preload("res://addons/silent_wolf/Scores/ScoreItem.tscn")
const OtherScoreItem = preload("res://addons/silent_wolf/Scores/OtherScoreItem.tscn")

var no_badge_art = preload("res://assets/art/ui/no_badge.png")
var bronze_badge_art = preload("res://assets/art/ui/bronze_badge.png")
var silver_badge_art = preload("res://assets/art/ui/silver_badge.png")
var gold_badge_art = preload("res://assets/art/ui/gold_badge.png")
var diamond_badge_art = preload("res://assets/art/ui/diamond_badge.png")
var developer_badge_art = preload("res://assets/art/ui/developer_badge.png")

var list_index = 0
var max_scores = stats.LEADERBOARD_MAX_SCORES

@onready var level_name = $VBoxContainer/level_name

@onready var best_time_badge = $main/main_content/scores_and_xp/score/best_time_section/best_time_badge
@onready var best_time_label = $main/main_content/scores_and_xp/score/best_time_section/time/best_time_label

@onready var bronze_time_label = $main/main_content/scores_and_xp/medals/bronze/bronze_time_label
@onready var silver_time_label = $main/main_content/scores_and_xp/medals/silver/silver_time_label
@onready var gold_time_label = $main/main_content/scores_and_xp/medals/gold/gold_time_label
@onready var diamond_time_label = $main/main_content/scores_and_xp/medals/diamond/diamond_time_label

@onready var developer_time = $main/main_content/scores_and_xp/medals/developer_time
@onready var developer_time_label = $main/main_content/scores_and_xp/medals/developer_time/developer_time_label

@onready var score_container = $main/main_content/leaderboard/ScrollContainer/score_container
@onready var leaderboard_label = $main/main_content/leaderboard/leaderboard_label

@onready var resume_button = $buttons/resume_button
@onready var restart_button = $buttons/restart_button

@onready var main = $main
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

func set_up_leaderboards(record_time, _level_name, level_id, level_id_board):
	list_index = 0
	clear_leaderboard()
	update_times(record_time, _level_name, level_id)
	load_scores(level_id_board)

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

func clear_leaderboard() -> void:
	if score_container.get_child_count() > 0:
		var children = score_container.get_children()
		for c in children:
			score_container.remove_child(c)
			c.queue_free()

func update_times(record_time, _level_name, level_id):
	update_badge_times(level_id)
	update_dev_time_visibiliy(record_time, level_id)
	update_badge_icons(record_time, level_id)
	best_time_label.text = "%02d:%02d:%03d" % [fmod(record_time, 60*60)/60, fmod(record_time,60), fmod(record_time, 1)*1000]
	level_name.text = _level_name

func update_badge_times(level_id):
	bronze_time_label.text = "%02d:%02d:%03d" % [fmod(stats["medal_times"][level_id]["bronze"], 60*60)/60, fmod(stats["medal_times"][level_id]["bronze"],60), fmod(stats["medal_times"][level_id]["bronze"], 1)*1000]
	silver_time_label.text = "%02d:%02d:%03d" % [fmod(stats["medal_times"][level_id]["silver"], 60*60)/60, fmod(stats["medal_times"][level_id]["silver"],60), fmod(stats["medal_times"][level_id]["silver"], 1)*1000]
	gold_time_label.text = "%02d:%02d:%03d" % [fmod(stats["medal_times"][level_id]["gold"], 60*60)/60, fmod(stats["medal_times"][level_id]["gold"],60), fmod(stats["medal_times"][level_id]["gold"], 1)*1000]
	diamond_time_label.text = "%02d:%02d:%03d" % [fmod(stats["medal_times"][level_id]["diamond"], 60*60)/60, fmod(stats["medal_times"][level_id]["diamond"],60), fmod(stats["medal_times"][level_id]["diamond"], 1)*1000]
	developer_time_label.text = "%02d:%02d:%03d" % [fmod(stats["medal_times"][level_id]["developer"], 60*60)/60, fmod(stats["medal_times"][level_id]["developer"],60), fmod(stats["medal_times"][level_id]["developer"], 1)*1000]

func update_dev_time_visibiliy(record_time, level_id):
	if record_time <= stats["medal_times"][level_id]["diamond"]:
		developer_time.visible = true

func update_badge_icons(record_time, level_id):
	if record_time <= stats["medal_times"][level_id]["developer"]:
		best_time_badge.texture = developer_badge_art
	elif record_time <= stats["medal_times"][level_id]["diamond"]:
		best_time_badge.texture = diamond_badge_art
	elif record_time <= stats["medal_times"][level_id]["gold"]:
		best_time_badge.texture = gold_badge_art
	elif record_time <= stats["medal_times"][level_id]["silver"]:
		best_time_badge.texture = silver_badge_art
	elif record_time <= stats["medal_times"][level_id]["bronze"]:
		best_time_badge.texture = bronze_badge_art


func load_scores(level_id):
	var sw_result = await SilentWolf.Scores.get_scores(0, level_id).sw_get_scores_complete
	var scores = sw_result.scores
	render_board(scores,level_id)

func render_board(scores,level_id):
	for score in scores:
		if score.has("metadata"):# and score.player_name != SilentWolf.Auth.logged_in_player:
			add_ghost_item(score.player_name, ("%02d:%02d:%03d" % [fmod(score.score*-1, 60*60)/60, fmod(score.score*-1,60), fmod(score.score*-1, 1)*1000]),score.metadata,level_id)
		else:
			add_item(score.player_name, ("%02d:%02d:%03d" % [fmod(score.score*-1, 60*60)/60, fmod(score.score*-1,60), fmod(score.score*-1, 1)*1000]))

func add_item(player_name: String, score_value: String):
	if list_index >= max_scores:
		return
	var item = ScoreItem.instantiate()
	list_index += 1
	item.get_node("PlayerName").text = str(list_index) + str(". ") + player_name
	item.get_node("Score").text = score_value
	item.offset_top = list_index * 100
	if player_name == SilentWolf.Auth.logged_in_player:
		item.get_node("PlayerName").add_theme_color_override("font_color",Color("#66cdaa"))
	score_container.add_child(item)

func add_ghost_item(player_name: String, score_value: String, metadata, level_id):
	if list_index >= max_scores:
		return
	var item = OtherScoreItem.instantiate()
	list_index += 1
	item.get_node("PlayerName").text = str(list_index) + str(". ") + player_name
	item.get_node("Score").text = score_value
	item.meta_data = metadata
	item.level_id = level_id
	item.offset_top = list_index * 100
	if player_name == SilentWolf.Auth.logged_in_player:
		item.get_node("PlayerName").add_theme_color_override("font_color",Color("#66cdaa"))
	score_container.add_child(item)
	item.connect("load_ghost",_on_ghost_button_pressed)

func _on_ghost_button_pressed(meta_data,level_id):
	stats.save_data[level_id]["other_ghost"] = meta_data
	change_pause()
	get_tree().reload_current_scene()

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
