extends Panel

@onready var button = $Button

var meta_data
var level_id

signal load_ghost(data,level)


func _on_button_pressed():
	emit_signal("load_ghost",meta_data,level_id)
