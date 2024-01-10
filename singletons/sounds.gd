extends Node

@onready var sound_players = $sfx.get_children()
@onready var music_player =$music
@onready var voice_player = $voice

var sfx_path = "res://assets/sfx/"
var music_path = "res://assets/music/"
var voice_path = "res://assets/voice/"

var sfx = {
	"smell_this_bread" : load(sfx_path+"smell_this_bread.wav"),
	"angel_1_1" : load(sfx_path+"angel_1_1.wav"),
	"enemy_die" : load(sfx_path+"enemy_die.wav"),
	"player_hurt" : load(sfx_path+"player_hurt.wav"),
	"player_jump" : load(sfx_path+"player_jump.wav"),
	"step" : load(sfx_path+"step.wav"),
	"dig" : load(sfx_path+"dig.wav"),
	"bark_once" : load(sfx_path+"bark_once.wav"),
	"bark_twice" : load(sfx_path+"bark_twice.wav"),
	"go" : load(sfx_path+"go.wav"),
	"clapping" : load(sfx_path+"clapping.wav"),
#	"" : load(sfx_path+".wav"),
#	"" : load(sfx_path+".wav"),
	}

var music = {
	"music_original" : load(music_path+"music_original.wav"),
	"menu" : load(music_path+"menu.wav"),
#	"" : load(music_path+".wav"),
}

var voices = {
#	"" : load(voice_path+".wav"),
}

var music_playing = null

func play_sfx(sound_string, pitch_scale = 1, volume_db = 0):
	for sound_player in sound_players:
		if !sound_player.playing:
			sound_player.pitch_scale = pitch_scale
			sound_player.volume_db = volume_db
			sound_player.stream = sfx[sound_string]
			sound_player.play()
			return
	print("Too many sounds playing")

func play_music(music_string, pitch_scale = 1, volume_db = 0):
	if music_playing != music_string:
		music_player.pitch_scale = pitch_scale
		music_player.volume_db = volume_db
		music_player.stream = music[music_string]
		music_player.play()
		music_playing = music_string

func play_voice(voice_string, pitch_scale = 1, volume_db = 0):
	if voice_player.playing:
		voice_player.stop()
	voice_player.pitch_scale = pitch_scale
	voice_player.volume_db = volume_db
	voice_player.stream = voices[voice_string]
	voice_player.play()

