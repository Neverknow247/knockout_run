@tool
extends VBoxContainer
var stats = Stats

const ScoreItem = preload("res://addons/silent_wolf/Scores/SmallScoreItem.tscn")
const SWLogger = preload("res://addons/silent_wolf/utils/SWLogger.gd")

@onready var score_item_container = $highscores/score_item_container

var list_index = 0
var ld_name = "level_1_1"

#var max_scores = stats.LEADERBOARD_MAX_SCORES
@export var max_scores = 10

func _ready():
	clear_leaderboard()
	load_scores(ld_name)

func load_scores(level_id):
	add_loading_scores_message()
	var sw_result = await SilentWolf.Scores.get_scores(0, level_id).sw_get_scores_complete
	var scores = sw_result.scores
	hide_message()
	render_board(scores)

func render_board(scores):
	if scores.is_empty():
		add_no_scores_message()
	else:
		for score in scores:
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
	score_item_container.add_child(item)

func add_no_scores_message() -> void:
	var item = $message_container/message_label
	item.text = "No scores yet!"
	$message_container.show()

func add_loading_scores_message() -> void:
	var item = $message_container/message_label
	item.text = "Loading scores..."
	$message_container.show()

func hide_message() -> void:
	$message_container.hide()

func clear_leaderboard() -> void:
	if score_item_container.get_child_count() > 0:
		var children = score_item_container.get_children()
		for c in children:
			score_item_container.remove_child(c)
			c.queue_free()


