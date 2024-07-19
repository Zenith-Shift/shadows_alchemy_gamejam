extends CharacterBody3D


const speed = 5.0

@export var jump_height : float
@export var jump_time_to_peak : float
@export var jump_time_to_fall : float
@export_range(0.0, 1.0) var friction = 0.1
@export_range(0.0 , 1.0) var acceleration = 0.25

@onready var jump_velocity : float = (2.0 * jump_height) / jump_time_to_peak
@onready var jump_gravity : float = (-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)
@onready var fall_gravity : float = (-2.0 * jump_height) / (jump_time_to_fall * jump_time_to_fall)

func _physics_process(delta):
	velocity.y += get_gravity() * delta
	if (get_input_velocity() != 0):
		velocity.x = lerp(velocity.x, get_input_velocity() * speed, acceleration)
	else:
		velocity.x = lerp(velocity.x, 0.0, friction)
	if Input.is_action_pressed('jump') and is_on_floor():
		jump()
	
	move_and_slide()

func get_gravity():
	return jump_gravity if velocity.y < 0.0 else fall_gravity
	
func jump():
	velocity.y = jump_velocity

func get_input_velocity() -> float:
	var horizontal = 0.0
	
	if Input.is_action_pressed('left'):
		horizontal -= 1.0
	elif Input.is_action_pressed('right'):
		horizontal += 1.0
	
	return horizontal




