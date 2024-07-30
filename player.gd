extends CharacterBody3D
# FORM VARIABLES -----------------------------------------------------------------------------------------
@export var form : Form = Form.dark
enum Form{
	light,
	dark
}
# SPEED VARIABLES -----------------------------------------------------------------------------------------
const speed = 5.0
const double_jump_cost = 20.0
var can_double_jump = false
@export var jump_height : float
@export var jump_time_to_peak : float
@export var jump_time_to_fall : float
@export_range(0.0, 1.0) var friction = 0.1
@export_range(0.0 , 1.0) var acceleration = 0.25
@onready var jump_velocity : float = (2.0 * jump_height) / jump_time_to_peak
@onready var jump_gravity : float = (-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)
@onready var fall_gravity : float = (-2.0 * jump_height) / (jump_time_to_fall * jump_time_to_fall)
@onready var animation_tree = $AnimationTree
var run_value = 0
var jump_value = 0
var fall_value = 0
var jump_buffer_time = 0.2 
var jump_buffer_timer = 0.0
var jump_pressed = false
enum {IDLE,RUN,JUMP,FALL}
@export var blend_speed = 15
var facing_right = true
var curAnim = IDLE
@onready var body: MeshInstance3D = $"Armature/Skeleton3D/Body mesh"

# COUNTER VARIABLES -----------------------------------------------------------------------------------------
var dark_mode_counter : float = 50.0
var light_mode_counter : float = 50.0
const counter_max : float = 100.0
const counter_fill_rate : float = 15.0  # units per second

# SPEED FUNCTIONS -----------------------------------------------------------------------------------------
func get_gravity():
	return jump_gravity if velocity.y < 0.0 else fall_gravity
	
func jump():
	velocity.y = jump_velocity

func get_input_velocity() -> float:
	var horizontal = 0.0
	
	if Input.is_action_pressed('left'):
		horizontal -= 1.0
		curAnim = RUN
	elif Input.is_action_pressed('right'):
		horizontal += 1.0
		curAnim = RUN
	return horizontal

# FORM FUNCTIONS -----------------------------------------------------------------------------------------
var entered_position: Vector3 = Vector3.ZERO
var exited_position: Vector3 = Vector3.ZERO

func _on_static_body_3d_body_entered(body: CharacterBody3D):
	if body == self:
		entered_position = self.global_transform.origin
func _on_static_body_3d_body_exited(body: CharacterBody3D):
	if body == self:
		exited_position = self.global_transform.origin
		if correct_exit(entered_position, exited_position):
			form = Form.dark if form == Form.light else Form.light
			change_form()
			
func correct_exit(entry: Vector3, exit: Vector3) -> bool:
	return abs(entry.x - exit.x) > 0.1

func change_form():
	if form == Form.light:
		print("I should be in light mode")
	elif form == Form.dark:
		print("I should be in dark mode")
	
func update_counters(delta):
	if form == Form.dark:
		dark_mode_counter = min(dark_mode_counter + counter_fill_rate * delta, counter_max)
		light_mode_counter = max(light_mode_counter - counter_fill_rate * delta, 0)
	elif form == Form.light:
		light_mode_counter = min(light_mode_counter + counter_fill_rate * delta, counter_max)
		dark_mode_counter = max(dark_mode_counter - counter_fill_rate * delta, 0)
		
	energy_bar_progress()
	
func energy_bar_progress():
	$SubViewport/EnergyBar.value = light_mode_counter
	
# PROCESS -----------------------------------------------------------------------------------------
func _ready():
	change_form()

func _physics_process(delta):
	velocity.y += get_gravity() * delta
	
	var input_velocity = get_input_velocity()
	if input_velocity != 0:
		velocity.x = lerp(velocity.x, get_input_velocity() * speed, acceleration)
		curAnim = RUN
	else:
		velocity.x = lerp(velocity.x, 0.0, friction)
		curAnim= IDLE

	if Input.is_action_just_pressed('jump'):
		jump_pressed = true
		jump_buffer_timer = 0.0
		
	if jump_pressed:
		jump_buffer_timer += delta
		if jump_buffer_timer > jump_buffer_time:
			jump_pressed = false

	if is_on_floor():
		if jump_pressed:
			jump()
			can_double_jump = true
			jump_pressed = false
	elif can_double_jump and Input.is_action_just_pressed('jump') and light_mode_counter >= double_jump_cost:
		jump()
		light_mode_counter -= double_jump_cost
		can_double_jump = false
		
	if velocity.y > 0:
		curAnim = JUMP
	elif velocity.y < -0.69:
		curAnim = FALL
	move_and_slide()
	update_counters(delta)
	update_direction(input_velocity)
	handle_animation(delta)
	update_tree()

func handle_animation(delta):
	match curAnim:
		IDLE:
			run_value = lerpf(run_value,0,blend_speed*delta)
			jump_value = lerpf(jump_value,0,blend_speed*delta)
			fall_value = lerpf(fall_value,0,blend_speed*delta)
		RUN:
			run_value = lerpf(run_value,1,blend_speed*delta)
			jump_value = lerpf(jump_value,0,blend_speed*delta)
			fall_value = lerpf(fall_value,0,blend_speed*delta)
		JUMP:
			run_value = lerpf(run_value,0,blend_speed*delta)
			jump_value = lerpf(jump_value,1,blend_speed*delta)
			fall_value = lerpf(fall_value,0,blend_speed*delta)
		FALL:
			run_value = lerpf(run_value,0,blend_speed*delta)
			jump_value = lerpf(jump_value,0,blend_speed*delta)
			fall_value = lerpf(fall_value,1,blend_speed*delta)
			
func update_tree():
	animation_tree["parameters/Blend2/blend_amount"] = run_value
	animation_tree["parameters/Blend20/blend_amount"] = jump_value
	animation_tree["parameters/Blend21/blend_amount"] = fall_value
func update_direction(input_velocity: float):
	if input_velocity < 0 and facing_right:
		body.rotate_y(deg_to_rad(180))
		facing_right = false
	elif input_velocity > 0 and !facing_right:
		body.rotate_y(deg_to_rad(180))
		facing_right = true
