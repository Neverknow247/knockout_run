extends Node2D

@onready var ray_cast_2d = $RayCast2D
@onready var lines = [
	$Line2D,$Line2D2,$Line2D3
]
@onready var area_2d = $Area2D

var collision_point = null
var separation = 8

signal player_dead

func _ready():
	check_collision()

func check_collision():
	if ray_cast_2d.is_colliding():
		collision_point = to_local(ray_cast_2d.get_collision_point())
		#prints("collission",to_local(ray_cast_2d.get_collision_point()))
		area_2d.scale.x = collision_point.x
		for line in lines:
			for x in range(0,collision_point.x,separation):
				line.add_point(Vector2(x,0))
			line.add_point(collision_point)

var surge = 0
func _process(delta):
	if !collision_point:
		print("set collision")
		check_collision()
	else:
		if surge == 2:
			surge = 0
		else:
			surge += 1
		for i in lines[surge].points.size():
			if i == 0 || i == lines[surge].points.size()-1:
				pass
			else:
				lines[surge].points[i].y = randf_range(-2.5,2.5)
				#lines[surge].points[i].y = lines[surge].points[i].y+randf_range(-.5,.5)
		#for line in lines:
			#for i in line.points.size():
				#if i == 0 || i == line.points.size()-1:
					#pass
				#else:
					#line.points[i].y = randf_range(-2.5,2.5)


func _on_area_2d_body_entered(body):
	player_dead.emit()
