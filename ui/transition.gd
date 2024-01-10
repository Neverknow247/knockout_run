extends ColorRect

@onready var animation_player = $AnimationPlayer

func fade_in():
	animation_player.play("fade_in")

func fade_out():
	animation_player.play("fade_out")

func fade_out_credits():
	animation_player.play("fade_out_credits")
