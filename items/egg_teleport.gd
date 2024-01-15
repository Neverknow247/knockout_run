extends Area2D

var sounds = Sounds
var stats = Stats

@export var stats_level_name : String
@export var secret_level : String
@export var sound_effect : String
@export var sdb = 10

signal change_scene(new_scene)

func _ready():
	if stats.dev_mode:
		pass
		#$CollisionShape2D.disabled = true
		#hide()

func _on_body_entered(body):
	sounds.play_sfx(sound_effect,randf_range(1.2,1.5),sdb)
	stats.save_data[stats_level_name]["unlocked"] = true
	change_scene.emit(secret_level)

