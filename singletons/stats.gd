extends Node

var dev_mode = true
var transition_time = .4

const LEADERBOARD_MAX_SCORES = 100

var medal_times = {
	level_1_1 = {
		"bronze" : 21.0000,
		"silver" : 15.5000,
		"gold" : 13.7500,
		"diamond" : 12.7500
	},
}

var new_save_data = {
	"version" : 1,
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
	"level_1_2" : {
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
