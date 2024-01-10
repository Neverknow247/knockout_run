extends Area2D

@export var damage = 1

func _on_area_entered(area):
	area.emit_signal("hit", damage)
