@tool
extends Control

var stats = Stats

const ScoreItem = preload("res://addons/silent_wolf/Scores/ScoreItem.tscn")
const SWLogger = preload("res://addons/silent_wolf/utils/SWLogger.gd")

@onready var level_label = $Board/TitleContainer/level_label
@onready var world_tabs = $tabs/world_tabs
@onready var level_tabs = $tabs/level_tabs
@onready var score_item_container = $Board/HighScores/ScrollContainer/ScoreItemContainer

@onready var transition = $transition

var list_index = 0
# Replace the leaderboard name if you're not using the default leaderboard
var ld_name = "level_1_1"

var max_scores = stats.LEADERBOARD_MAX_SCORES
var world_tab = 0
#var level_tab = 0

var tabs_disabled = false
var world_tabs_num = 0
#var level_tabs_num = 9

#var ld_names = [
	#["level_1_1",
	#"level_1_2",
	#"level_1_3",
	#"level_1_4",
	#"level_1_5",
	#"level_1_6",
	#"level_1_7",
	#"level_1_8",
	#"level_1_9"],
	#["level_2_1",
	#"level_2_2",
	#"level_2_3",
	#"level_2_4",
	#"level_2_5",
	#"level_2_6",
	#"level_2_7",
	#"level_2_8",
	#"level_2_9"],
#]
#var ld_labels = [
	#["Forest 1",
	#"Forest 2",
	#"Forest 3",
	#"Forest 4",
	#"Forest 5",
	#"Forest 6",
	#"Forest 7",
	#"Forest 8",
	#"Forest 9"],
	#["Caves 1",
	#"Caves 2",
	#"Caves 3",
	#"Caves 4",
	#"Caves 5",
	#"Caves 6",
	#"Caves 7",
	#"Caves 8",
	#"Caves 9"],
#]

var level_names = [
	"Knockout Run",
	"Sheep"
]

var ld_names = [
	"level_1_1",
	"level_sheep"
]

var unlocked_ld_names = []
var unlocked_level_names = []

func _ready():
	set_tabs()
	clear_leaderboard()
	set_tabs_disable()
	load_scores()

func set_tabs():
	for i in ld_names.size():
		var level = ld_names[i]
		if stats.save_data[level]['unlocked']:
			world_tabs_num += 1
			unlocked_ld_names.append(ld_names[i])
			unlocked_level_names.append(level_names[i])
			world_tabs.add_tab(level_names[i])

func load_scores():
#	print("SilentWolf.Scores.leaderboards: " + str(SilentWolf.Scores.leaderboards))
#	print("SilentWolf.Scores.ldboard_config: " + str(SilentWolf.Scores.ldboard_config))
	var scores = SilentWolf.Scores.scores
	#var scores = []
	if ld_name in SilentWolf.Scores.leaderboards:
		scores = SilentWolf.Scores.leaderboards[ld_name]
	var local_scores = SilentWolf.Scores.local_scores
	
	if false:
		pass
#	if len(scores) > 0: 
#		render_board(scores, local_scores)
	else:
		# use a signal to notify when the high scores have been returned, and show a "loading" animation until it's the case...
		add_loading_scores_message()
		var sw_result = await SilentWolf.Scores.get_scores(0, ld_name).sw_get_scores_complete
		scores = sw_result.scores
		hide_message()
		render_board(scores, local_scores)
		set_tabs_disable()

func render_board(scores: Array, local_scores: Array) -> void:
	var all_scores = scores
	if ld_name in SilentWolf.Scores.ldboard_config and is_default_leaderboard(SilentWolf.Scores.ldboard_config[ld_name]):
		all_scores = merge_scores_with_local_scores(scores, local_scores)
		if scores.is_empty() and local_scores.is_empty():
			add_no_scores_message()
	else:
		if scores.is_empty():
			add_no_scores_message()
	if all_scores.is_empty():
		for score in scores:
			add_item(score.player_name, str((score.score)*-1))
			add_item(score.player_name, ("%02d:%02d:%03d" % [fmod(score.score*-1, 60*60)/60, fmod(score.score*-1,60), fmod(score.score*-1, 1)*1000]))
	else:
		for score in all_scores:
			add_item(score.player_name, ("%02d:%02d:%03d" % [fmod(score.score*-1, 60*60)/60, fmod(score.score*-1,60), fmod(score.score*-1, 1)*1000]))
#			add_item(score.player_name, str((score.score)*-1))


func is_default_leaderboard(ld_config: Dictionary) -> bool:
	var default_insert_opt = (ld_config.insert_opt == "keep")
	var not_time_based = !("time_based" in ld_config)
	return default_insert_opt and not_time_based


func merge_scores_with_local_scores(scores: Array[Dictionary], local_scores: Array[Dictionary]) -> Array[Dictionary]:
	if local_scores:
		for score in local_scores:
			var in_array = score_in_score_array(scores, score)
			if !in_array:
				scores.append(score)
			scores.sort_custom(sort_by_score);
	var return_scores = scores
	if scores.size() > max_scores:
		return_scores = scores.resize(max_scores)
	return return_scores


func sort_by_score(a: Dictionary, b: Dictionary) -> bool:
	if a.score > b.score:
		return true;
	else:
		if a.score < b.score:
			return false;
		else:
			return true;


func score_in_score_array(scores: Array[Dictionary], new_score: Dictionary) -> bool:
	var in_score_array =  false
	if !new_score.is_empty() and !scores.is_empty():
		for score in scores:
			if score.score_id == new_score.score_id: # score.player_name == new_score.player_name and score.score == new_score.score:
				in_score_array = true
	return in_score_array


func add_item(player_name: String, score_value: String) -> void:
	if list_index >= max_scores:
		return
	var item = ScoreItem.instantiate()
	list_index += 1
	item.get_node("PlayerName").text = str(list_index) + str(". ") + player_name
	item.get_node("Score").text = score_value
	item.offset_top = list_index * 100
	if player_name == SilentWolf.Auth.logged_in_player:
		item.get_node("PlayerName").add_theme_color_override("font_color",Color("#66cdaa"))
	score_item_container.add_child(item)


func add_no_scores_message() -> void:
	var item = $"Board/MessageContainer/TextMessage"
	item.text = "No scores yet!"
	$"Board/MessageContainer".show()
#	item.margin_top = 135


func add_loading_scores_message() -> void:
	var item = $"Board/MessageContainer/TextMessage"
	item.text = "Loading scores..."
	$"Board/MessageContainer".show()
#	item.margin_top = 135


func hide_message() -> void:
	$"Board/MessageContainer".hide()


func clear_leaderboard() -> void:
	if score_item_container.get_child_count() > 0:
		var children = score_item_container.get_children()
		for c in children:
			score_item_container.remove_child(c)
			c.queue_free()


func _on_CloseButton_pressed() -> void:
	var scene_name = SilentWolf.scores_config.open_scene_on_close
	SWLogger.info("Closing SilentWolf leaderboard, switching to scene: " + str(scene_name))
	#global.reset()
	get_tree().change_scene_to_file(scene_name)


func change_tab():
	clear_leaderboard()
	list_index = 0
	load_scores()
	transition.fade_in()

func _on_world_tabs_tab_clicked(tab):
	transition.fade_out()
	await get_tree().create_timer(stats.transition_time).timeout
	set_tabs_disable()
	world_tab = tab
	ld_name = unlocked_ld_names[world_tab]
	level_label.text = unlocked_level_names[world_tab]
	#ld_name = ld_names[world_tab][level_tab]
	#level_label.text = ld_labels[world_tab][level_tab]
	change_tab()

#func _on_level_tabs_tab_clicked(tab):
	#transition.fade_out()
	#await get_tree().create_timer(stats.transition_time).timeout
	#set_tabs_disable()
	#level_tab = tab
	#ld_name = ld_names[world_tab][level_tab]
	#level_label.text = ld_labels[world_tab][level_tab]
	#change_tab()

func set_tabs_disable():
	tabs_disabled = !tabs_disabled
	for i in world_tabs_num:
		world_tabs.set_tab_disabled(i,tabs_disabled)
	#for i in level_tabs_num:
		#level_tabs.set_tab_disabled(i,tabs_disabled)


func _on_back_button_pressed():
	transition.fade_out()
	await get_tree().create_timer(stats.transition_time).timeout
	get_tree().change_scene_to_file("res://menus/main_menu.tscn")
