extends StaticBody2D

signal level_complete

func _on_area_2d_body_entered(body):
	level_complete.emit()
