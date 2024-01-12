extends CharacterBody2D

var sounds = Sounds
var stats = Stats

const step_particles = preload("res://particles/step_particles.tscn")

func add_particle():
	var part = step_particles.instantiate()
	get_parent().add_child(part)
	part.position = global_position

var current_velocity = 0
#@export var acceleration = 512
@export var acceleration = 600
@export var default_max_velocity = 100
@export var max_velocity = 100
#@export var dash_bonus = 100
@export var dash_bonus = 200
#@export var slide_bonus = 75
@export var slide_bonus = 50
#@export var ledge_bonus = 50
@export var ledge_bonus = 50
@export var friction = 512
@export var wall_friction = 10
@export var ground_friction = 20
@export var air_friction = 0
@export var max_fall_velocity = 180
@export var gravity = 500
@export var jump_force = 210
#@export var jump_force = 200
@export var max_wall_slide_speed = 180
@export var wall_slide_speed = 90
@export var wall_climb_speed = 30

@onready var sprite = $sprite
@onready var outline_sprite = $outline_sprite
@onready var dash_sprite = $dash_sprite
@onready var coyote_jump_timer = $coyote_jump_timer
@onready var slide_timer = $slide_timer
@onready var dash_timer = $dash_timer
@onready var move_tech_timer = $move_tech_timer
@onready var slide_player = $slide_player
@onready var dash_player = $dash_player
@onready var particles_1 = $particles_1

var air_jump = false:
	get:
		return air_jump
	set(value):
		air_jump = value
		if air_jump == true:
			outline_sprite.self_modulate = Color.WHITE
		else:
			outline_sprite.self_modulate = Color("#7b5fff")

var slide = true
var slide_tech_time = 0.4
var dash = true
var dash_tech_time = 0.1
var is_move_tech = false

var state = move_state

signal start_level

func _ready():
	sprite.modulate = stats.save_data["runner_color"]

func _physics_process(delta):
	current_velocity = abs(velocity.x)
	state.call(delta)

func move_state(delta):
	apply_gravity(delta)
	var input_axis = Input.get_axis("left", "right")
	if is_moving(input_axis):
		if is_on_floor() and current_velocity > 100:
			particles_1.emitting = true
			particles_1.direction.x = -input_axis
			particles_1.initial_velocity_max = current_velocity/4
		else:
			particles_1.emitting = false
		apply_acceleration(delta,input_axis)
	else:
		particles_1.emitting = false
		apply_friction(delta)
	jump_check()
	dash_check()
	slide_check()
	var was_on_floor = is_on_floor()
	move_and_slide()
	var just_left_edge = was_on_floor and not is_on_floor() and velocity.y >= 0
	if just_left_edge:
		coyote_jump_timer.start()
	wall_check()
	reset_velocity_check()

func reset_velocity_check():
	if !is_move_tech and is_on_floor():
		max_velocity = max(max_velocity-ground_friction,default_max_velocity)
		#slide_player.play("RESET")

func wall_slide_state(delta):
	var wall_normal = sign(get_wall_normal().x)
	velocity.y = clampf(velocity.y, -max_wall_slide_speed, max_wall_slide_speed)
	wall_jump_check(wall_normal)
	apply_wall_slide_gravity(delta)
	move_and_slide()
	wall_detach(delta)

func wall_check():
	if not is_on_floor() and is_on_wall():
		state = wall_slide_state
		air_jump = true
		max_velocity = max(max_velocity-wall_friction,default_max_velocity)
		#slide_player.play("RESET")

func wall_detach(delta):
	if Input.is_action_just_pressed("right"):
		velocity.x = acceleration * delta
		state = move_state
	if Input.is_action_just_pressed("left"):
		velocity.x = -acceleration * delta
		state = move_state
	if not is_on_wall() and not is_on_ceiling() or is_on_floor():
		state = move_state
#
func wall_jump_check(wall_axis):
	if Input.is_action_just_pressed("jump"):
		#velocity.x = wall_axis*max(default_max_velocity,min(default_max_velocity*2,max_velocity/2))
		velocity.x = wall_axis*default_max_velocity
		state = move_state
		jump(jump_force*0.75,false)
		var wall_jump_effect_position = global_position+Vector2(wall_axis*3.5,-2)
#
func apply_wall_slide_gravity(delta):
	var slide_speed = wall_slide_speed
	if Input.is_action_pressed("slide_wallslide"):
		slide_speed = max_wall_slide_speed
	else:
		slide_speed = wall_slide_speed
	velocity.y = move_toward(velocity.y, slide_speed, gravity * delta)
#
func is_moving(input_axis):
	return input_axis != 0
#
func apply_gravity(delta):
	if not is_on_floor():
		velocity.y = move_toward(velocity.y, max_fall_velocity, gravity * delta)

func apply_acceleration(delta, input_axis):
	velocity.x = move_toward(velocity.x, input_axis * max_velocity, acceleration * delta)

func apply_friction(delta):
	if is_on_floor():
		velocity.x = move_toward(velocity.x, 0, friction * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, air_friction * delta)

func jump_check():
	if is_on_floor():
		air_jump = true
		dash_sprite.modulate = Color("ffffff")
	else:
		particles_1.emitting = false
		dash_sprite.modulate = Color("ffffff0f")
	if is_on_floor() or coyote_jump_timer.time_left > 0.0:
		if Input.is_action_just_pressed("jump"):
			max_velocity = max(default_max_velocity,current_velocity)
			if coyote_jump_timer.time_left > 0.0:
				max_velocity += ledge_bonus
			jump(jump_force)
	elif not is_on_floor():
		if Input.is_action_just_released("jump") and velocity.y < -jump_force / 2:
			velocity.y = -jump_force / 2
		if Input.is_action_just_pressed("jump") and air_jump:
			jump(jump_force * 0.75,false,true)
			air_jump = false

func jump(force, create_effect = true, air_jump = false):
	velocity.y = -force

func dash_check():
	if Input.is_action_just_pressed("dash") and is_on_floor() and dash:
		dash = false
		is_move_tech = true
		max_velocity += dash_bonus
		dash_timer.start()
		move_tech_timer.start(dash_tech_time)
		dash_player.stop()
		dash_player.play("dash_charge")

func _on_dash_timer_timeout():
	dash = true

func slide_check():
	if Input.is_action_just_pressed("slide_wallslide") and is_on_floor() and slide:
		slide_player.play("squish")
		dash = false
		slide = false
		is_move_tech = true
		max_velocity += slide_bonus
		dash_timer.start()
		slide_timer.start()
		move_tech_timer.start(slide_tech_time)

func _on_slide_timer_timeout():
	slide_player.play("RESET")
	slide = true

func _on_move_tech_timer_timeout():
	is_move_tech = false

var start = false
func _on_start_level_area_area_exited(area):
	if !start:
		area.play()
		start_level.emit()
		start = !start




