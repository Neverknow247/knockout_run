extends Node

var stats = Stats
var utils = Utils

var dev_mode = stats.dev_mode

var default_save_path
var SAVE_DATA_PATH
var SAVE_SETTINGS_PATH

var default_save_data = stats.new_save_data

#var default_save_data = {
	#version = 1,
	#volume_settings = {
		#"master_volume" = 1,
		#"music_volume" = 1,
		#"sfx_volume" = 1,
		#"voices_volume" = 1
	#},
	#power_on_count = 0,
	#
	#other_ghosts = {
		#"level_1_1":{
			#"positions":[],
			#"frames":[],
			#"facing":[],
			#"hat_positions":[],
			#"ear_frames":[],
			#"hat":"",
			#"dog":"",
			#"name_and_time":"",
		#},
		#"level_1_2":{
			#"positions":[],
			#"frames":[],
			#"facing":[],
			#"hat_positions":[],
			#"ear_frames":[],
			#"hat":"",
			#"dog":"",
			#"name_and_time":"",
		#},
		#"level_1_3":{
			#"positions":[],
			#"frames":[],
			#"facing":[],
			#"hat_positions":[],
			#"ear_frames":[],
			#"hat":"",
			#"dog":"",
			#"name_and_time":"",
		#},
		#"level_1_4":{
			#"positions":[],
			#"frames":[],
			#"facing":[],
			#"hat_positions":[],
			#"ear_frames":[],
			#"hat":"",
			#"dog":"",
			#"name_and_time":"",
		#},
		#"level_1_5":{
			#"positions":[],
			#"frames":[],
			#"facing":[],
			#"hat_positions":[],
			#"ear_frames":[],
			#"hat":"",
			#"dog":"",
			#"name_and_time":"",
		#},
		#"level_1_6":{
			#"positions":[],
			#"frames":[],
			#"facing":[],
			#"hat_positions":[],
			#"ear_frames":[],
			#"hat":"",
			#"dog":"",
			#"name_and_time":"",
		#},
		#"level_1_7":{
			#"positions":[],
			#"frames":[],
			#"facing":[],
			#"hat_positions":[],
			#"ear_frames":[],
			#"hat":"",
			#"dog":"",
			#"name_and_time":"",
		#},
		#"level_1_8":{
			#"positions":[],
			#"frames":[],
			#"facing":[],
			#"hat_positions":[],
			#"ear_frames":[],
			#"hat":"",
			#"dog":"",
			#"name_and_time":"",
		#},
		#"level_1_9":{
			#"positions":[],
			#"frames":[],
			#"facing":[],
			#"hat_positions":[],
			#"ear_frames":[],
			#"hat":"",
			#"dog":"",
			#"name_and_time":"",
		#},
		#"level_2_1":{
			#"positions":[],
			#"frames":[],
			#"facing":[],
			#"hat_positions":[],
			#"ear_frames":[],
			#"hat":"",
			#"dog":"",
			#"name_and_time":"",
		#},
		#"level_2_2":{
			#"positions":[],
			#"frames":[],
			#"facing":[],
			#"hat_positions":[],
			#"ear_frames":[],
			#"hat":"",
			#"dog":"",
			#"name_and_time":"",
		#},
		#"level_2_3":{
			#"positions":[],
			#"frames":[],
			#"facing":[],
			#"hat_positions":[],
			#"ear_frames":[],
			#"hat":"",
			#"dog":"",
			#"name_and_time":"",
		#},
		#"level_2_4":{
			#"positions":[],
			#"frames":[],
			#"facing":[],
			#"hat_positions":[],
			#"ear_frames":[],
			#"hat":"",
			#"dog":"",
			#"name_and_time":"",
		#},
		#"level_2_5":{
			#"positions":[],
			#"frames":[],
			#"facing":[],
			#"hat_positions":[],
			#"ear_frames":[],
			#"hat":"",
			#"dog":"",
			#"name_and_time":"",
		#},
		#"level_2_6":{
			#"positions":[],
			#"frames":[],
			#"facing":[],
			#"hat_positions":[],
			#"ear_frames":[],
			#"hat":"",
			#"dog":"",
			#"name_and_time":"",
		#},
		#"level_2_7":{
			#"positions":[],
			#"frames":[],
			#"facing":[],
			#"hat_positions":[],
			#"ear_frames":[],
			#"hat":"",
			#"dog":"",
			#"name_and_time":"",
		#},
		#"level_2_8":{
			#"positions":[],
			#"frames":[],
			#"facing":[],
			#"hat_positions":[],
			#"ear_frames":[],
			#"hat":"",
			#"dog":"",
			#"name_and_time":"",
		#},
		#"level_2_9":{
			#"positions":[],
			#"frames":[],
			#"facing":[],
			#"hat_positions":[],
			#"ear_frames":[],
			#"hat":"",
			#"dog":"",
			#"name_and_time":"",
		#},
	#},
	#
	#ninja_num = 0,
	#equiped_hat_sprite = "none",
	#equiped_dog_sprite = "akamaru",
	#
	#speed_run_mode = false,
	#ninja_mode = false,
	#iron_dog_mode = false,
	#iron_ninja_mode = false,
	#dog_dash = {
		#"time" : 86399.9999
	#},
	#iron_dog = {
		#"time" : 86399.9999
	#},
	#ninja_dash = {
		#"time" : 86399.9999
	#},
	#iron_ninja = {
		#"time" : 86399.9999
	#},
	#level_1_1 = {
		#"unlocked" : true,
		#"time" : 3599.9999,
		#"ninja_time" : 3599.9999,
		#"bone" : false,
		#"bone_location" : null,
		#"bone_dog_bowl" : false,
		#"egg" : false,
		#"ghost":{
			#"positions":[],
			#"frames":[],
			#"facing":[],
			#"hat_positions":[],
			#"ear_frames":[],
			#"hat":"",
			#"dog":"",
		#},
	#},
	#level_1_2 = {
		#"unlocked" : false,
		#"time" : 3599.9999,
		#"ninja_time" : 3599.9999,
		#"bone" : false,
		#"bone_location" : null,
		#"bone_dog_bowl" : false,
		#"egg" : false,
		#"ghost":{
			#"positions":[],
			#"frames":[],
			#"facing":[],
			#"hat_positions":[],
			#"ear_frames":[],
			#"hat":"",
			#"dog":"",
		#},
	#},
	#level_1_3 = {
		#"unlocked" : false,
		#"time" : 3599.9999,
		#"ninja_time" : 3599.9999,
		#"bone" : false,
		#"bone_location" : null,
		#"bone_dog_bowl" : false,
		#"egg" : false,
		#"ghost":{
			#"positions":[],
			#"frames":[],
			#"facing":[],
			#"hat_positions":[],
			#"ear_frames":[],
			#"hat":"",
			#"dog":"",
		#},
	#},
	#level_1_4 = {
		#"unlocked" : false,
		#"time" : 3599.9999,
		#"ninja_time" : 3599.9999,
		#"bone" : false,
		#"bone_location" : null,
		#"bone_dog_bowl" : false,
		#"egg" : false,
		#"ghost":{
			#"positions":[],
			#"frames":[],
			#"facing":[],
			#"hat_positions":[],
			#"ear_frames":[],
			#"hat":"",
			#"dog":"",
		#},
	#},
	#level_1_5 = {
		#"unlocked" : false,
		#"time" : 3599.9999,
		#"ninja_time" : 3599.9999,
		#"bone" : false,
		#"bone_location" : null,
		#"bone_dog_bowl" : false,
		#"egg" : false,
		#"ghost":{
			#"positions":[],
			#"frames":[],
			#"facing":[],
			#"hat_positions":[],
			#"ear_frames":[],
			#"hat":"",
			#"dog":"",
		#},
	#},
	#level_1_6 = {
		#"unlocked" : false,
		#"time" : 3599.9999,
		#"ninja_time" : 3599.9999,
		#"bone" : false,
		#"bone_location" : null,
		#"bone_dog_bowl" : false,
		#"egg" : false,
		#"ghost":{
			#"positions":[],
			#"frames":[],
			#"facing":[],
			#"hat_positions":[],
			#"ear_frames":[],
			#"hat":"",
			#"dog":"",
		#},
	#},
	#level_1_7 = {
		#"unlocked" : false,
		#"time" : 3599.9999,
		#"ninja_time" : 3599.9999,
		#"bone" : false,
		#"bone_location" : null,
		#"bone_dog_bowl" : false,
		#"egg" : false,
		#"ghost":{
			#"positions":[],
			#"frames":[],
			#"facing":[],
			#"hat_positions":[],
			#"ear_frames":[],
			#"hat":"",
			#"dog":"",
		#},
	#},
	#level_1_8 = {
		#"unlocked" : false,
		#"time" : 3599.9999,
		#"ninja_time" : 3599.9999,
		#"bone" : false,
		#"bone_location" : null,
		#"bone_dog_bowl" : false,
		#"egg" : false,
		#"ghost":{
			#"positions":[],
			#"frames":[],
			#"facing":[],
			#"hat_positions":[],
			#"ear_frames":[],
			#"hat":"",
			#"dog":"",
		#},
	#},
	#level_1_9 = {
		#"unlocked" : false,
		#"time" : 3599.9999,
		#"ninja_time" : 3599.9999,
		#"bone" : false,
		#"bone_location" : null,
		#"bone_dog_bowl" : false,
		#"egg" : false,
		#"ghost":{
			#"positions":[],
			#"frames":[],
			#"facing":[],
			#"hat_positions":[],
			#"ear_frames":[],
			#"hat":"",
			#"dog":"",
		#},
	#},
	#level_2_1 = {
		#"unlocked" : false,
		#"time" : 3599.9999,
		#"ninja_time" : 3599.9999,
		#"bone" : false,
		#"bone_location" : null,
		#"bone_dog_bowl" : false,
		#"egg" : false,
		#"ghost":{
			#"positions":[],
			#"frames":[],
			#"facing":[],
			#"hat_positions":[],
			#"ear_frames":[],
			#"hat":"",
			#"dog":"",
		#},
	#},
	#level_2_2 = {
		#"unlocked" : false,
		#"time" : 3599.9999,
		#"ninja_time" : 3599.9999,
		#"bone" : false,
		#"bone_location" : null,
		#"bone_dog_bowl" : false,
		#"egg" : false,
		#"ghost":{
			#"positions":[],
			#"frames":[],
			#"facing":[],
			#"hat_positions":[],
			#"ear_frames":[],
			#"hat":"",
			#"dog":"",
		#},
	#},
	#level_2_3 = {
		#"unlocked" : false,
		#"time" : 3599.9999,
		#"ninja_time" : 3599.9999,
		#"bone" : false,
		#"bone_location" : null,
		#"bone_dog_bowl" : false,
		#"egg" : false,
		#"ghost":{
			#"positions":[],
			#"frames":[],
			#"facing":[],
			#"hat_positions":[],
			#"ear_frames":[],
			#"hat":"",
			#"dog":"",
		#},
	#},
	#level_2_4 = {
		#"unlocked" : false,
		#"time" : 3599.9999,
		#"ninja_time" : 3599.9999,
		#"bone" : false,
		#"bone_location" : null,
		#"bone_dog_bowl" : false,
		#"egg" : false,
		#"ghost":{
			#"positions":[],
			#"frames":[],
			#"facing":[],
			#"hat_positions":[],
			#"ear_frames":[],
			#"hat":"",
			#"dog":"",
		#},
	#},
	#level_2_5 = {
		#"unlocked" : false,
		#"time" : 3599.9999,
		#"ninja_time" : 3599.9999,
		#"bone" : false,
		#"bone_location" : null,
		#"bone_dog_bowl" : false,
		#"egg" : false,
		#"ghost":{
			#"positions":[],
			#"frames":[],
			#"facing":[],
			#"hat_positions":[],
			#"ear_frames":[],
			#"hat":"",
			#"dog":"",
		#},
	#},
	#level_2_6 = {
		#"unlocked" : false,
		#"time" : 3599.9999,
		#"ninja_time" : 3599.9999,
		#"bone" : false,
		#"bone_location" : null,
		#"bone_dog_bowl" : false,
		#"egg" : false,
		#"ghost":{
			#"positions":[],
			#"frames":[],
			#"facing":[],
			#"hat_positions":[],
			#"ear_frames":[],
			#"hat":"",
			#"dog":"",
		#},
	#},
	#level_2_7 = {
		#"unlocked" : false,
		#"time" : 3599.9999,
		#"ninja_time" : 3599.9999,
		#"bone" : false,
		#"bone_location" : null,
		#"bone_dog_bowl" : false,
		#"egg" : false,
		#"ghost":{
			#"positions":[],
			#"frames":[],
			#"facing":[],
			#"hat_positions":[],
			#"ear_frames":[],
			#"hat":"",
			#"dog":"",
		#},
	#},
	#level_2_8 = {
		#"unlocked" : false,
		#"time" : 3599.9999,
		#"ninja_time" : 3599.9999,
		#"bone" : false,
		#"bone_location" : null,
		#"bone_dog_bowl" : false,
		#"egg" : false,
		#"ghost":{
			#"positions":[],
			#"frames":[],
			#"facing":[],
			#"hat_positions":[],
			#"ear_frames":[],
			#"hat":"",
			#"dog":"",
		#},
	#},
	#level_2_9 = {
		#"unlocked" : false,
		#"time" : 3599.9999,
		#"ninja_time" : 3599.9999,
		#"bone" : false,
		#"bone_location" : null,
		#"bone_dog_bowl" : false,
		#"egg" : false,
		#"ghost":{
			#"positions":[],
			#"frames":[],
			#"facing":[],
			#"hat_positions":[],
			#"ear_frames":[],
			#"hat":"",
			#"dog":"",
		#},
	#},
#}

func _ready():
	var logged_settings_path
	if dev_mode == true:
		logged_settings_path = "res://save_data/settings.cfg"
		default_save_path = "res://save_data/default_save_data.dat"
	else:
		logged_settings_path = "user://settings.cfg"
		default_save_path = "user://default_save_data.dat"
	SAVE_SETTINGS_PATH = logged_settings_path

func change_save_location():
	if SilentWolf.Auth.logged_in_player != null:
		var logged_save_path
		if dev_mode == true:
			logged_save_path = "res://save_data/%s_save_data.dat" % [SilentWolf.Auth.logged_in_player]
		else:
			logged_save_path = "user://%s_save_data.dat" % [SilentWolf.Auth.logged_in_player]
		SAVE_DATA_PATH = logged_save_path
	else:
		SAVE_DATA_PATH = default_save_path

func save_all():
	update_save_data()
	update_settings()

func save_data_to_file(save_data):
	var file = FileAccess.open(SAVE_DATA_PATH, FileAccess.WRITE)
	file.store_var(save_data)
	file.close()

func load_data_from_file():
	if not FileAccess.file_exists(SAVE_DATA_PATH):
		return default_save_data
	var file = FileAccess.open(SAVE_DATA_PATH, FileAccess.READ)
	var save_data = file.get_var()
	if save_data.version < default_save_data.version:
		save_data = check_old_data(save_data)
	elif save_data.version > default_save_data.version:
		get_tree().change_scene_to_file("res://menus/new_version_screen.tscn")
	return save_data

func update_save_data():
	var save_data = load_data_from_file()
	for stat in stats.save_data:
		save_data[stat] = stats.save_data[stat]
	SaveAndLoad.save_data_to_file(save_data)
	load_data()

func load_data():
	var save_data = load_data_from_file()
	for stat in save_data:
		stats.save_data[stat] = save_data[stat]

func check_old_data(save_data):
	var version = default_save_data.version
	for data in default_save_data:
		if !data in save_data:
			save_data[data] = default_save_data[data]
	save_data.version = version
	return save_data

func update_settings():
	var settings = ConfigFile.new()
	settings.set_value("volume_settings","setting",utils.volume_settings)
	settings.save(SAVE_SETTINGS_PATH)
	load_settings()

func load_settings():
	var settings = ConfigFile.new()
	var err = settings.load(SAVE_SETTINGS_PATH)
	if err != OK:
		return
	for setting in settings.get_sections():
		var single_setting = settings.get_value(setting, "setting")
		utils[setting] = single_setting
