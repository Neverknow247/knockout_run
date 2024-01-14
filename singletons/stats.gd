extends Node

var dev_mode = true
var transition_time = .2

const LEADERBOARD_MAX_SCORES = 100

var medal_times = {
	level_1_1 = {
		"bronze" : 42.0000,
		"silver" : 29.5000,
		"gold" : 20.7500,
		"diamond" : 15.7500,
		"developer" : 8.56669,
	},
	level_sheep = {
		"bronze" : 42.0000,
		"silver" : 29.5000,
		"gold" : 20.7500,
		"diamond" : 15.7500,
		"developer" : 8.56669,
	},
}

var new_save_data = {
	"version" : 1.1,
	"power_on_count" : 0,
	"tutorial_complete" : false,
	"runner_color" : Color(1, 1, 1, 1),
	"level_1_1" : {
		"unlocked" : true,
		"time" : 3599.9999,
		"ghost":{
			"positions":[],
			"color":Color.WHITE,
		},
		"other_ghost":{
			"positions":[],
			"color":Color.WHITE,
		},
	},
	"level_sheep" : {
		"unlocked" : false,
		"time" : 3599.9999,
		"ghost":{
			"positions":[],
			"color":Color.WHITE,
		},
		"other_ghost":{
			"positions":[],
			"color":Color.WHITE,
		},
	},
}

var save_data = new_save_data.duplicate(true)

func delete_save():
	save_data = new_save_data.duplicate(true)
