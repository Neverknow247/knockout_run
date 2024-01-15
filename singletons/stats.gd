extends Node

var dev_mode = false
var transition_time = .2

const LEADERBOARD_MAX_SCORES = 1000

var medal_times = {
	level_1_1 = {
		"bronze" : 42.0000,
		"silver" : 29.5000,
		"gold" : 20.7500,
		"diamond" : 15.7500,
		"developer" : 8.56669,
	},
	level_sheep = {
		"bronze" : 32.7500,
		"silver" : 25.0000,
		"gold" : 18.5000,
		"diamond" : 16.7500,
		"developer" : 11.0339,
	},
	level_toilet = {
		"bronze" : 45.0000,
		"silver" : 35.5000,
		"gold" : 25.5000,
		"diamond" : 20.7500,
		"developer" : 13.48339,
	},
	level_doggo = {
		"bronze" : 30.5000,
		"silver" : 19.7500,
		"gold" : 12.5000,
		"diamond" : 8.7500,
		"developer" : 3.41669,
	},
	level_firehazard = {
		"bronze" : 30.7500,
		"silver" : 15.5000,
		"gold" : 12.0000,
		"diamond" : 10.5000,
		"developer" : 4.43339,
	},
}

var new_save_data = {
	"version" : 1.2,
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
	"level_toilet" : {
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
	"level_doggo" : {
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
	"level_firehazard" : {
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
