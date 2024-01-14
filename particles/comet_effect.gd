extends Line2D

@export var speed = 5
@export var fade_distance = 20

func _process(delta):
	#points[0] = get_global_mouse_position()
	points[0] = global_position
	
	for i in points.size():
		if i == 0:
			continue
		
		points[i] = lerp(points[i], points[i - 1], delta * speed)
	
	var end_point = points[points.size() - 1]
	#var distance = end_point.distance_to(get_global_mouse_position())
	var distance = end_point.distance_to(global_position)
	if distance < fade_distance:
		modulate.a = inverse_lerp(0, fade_distance, distance)
	else:
		modulate.a = 1
