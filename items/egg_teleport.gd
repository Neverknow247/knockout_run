extends Area2D

var sounds = Sounds
var stats = Stats

@export var stats_level_name : String
@export var secret_level : String
@export var sound_effect : String

func _on_body_entered(body):
	sounds.play_sfx(sound_effect,randf_range(1.2,1.5),10)
	stats.save_data[stats_level_name]["unlocked"] = true
	get_tree().change_scene_to_file(secret_level)
