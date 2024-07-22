extends CharacterBody3D
# FORM VARIABLES -----------------------------------------------------------------------------------------
@export var form : Form = Form.dark

enum Form{
	light,
	dark
}
# SPEED VARIABLES -----------------------------------------------------------------------------------------
const speed = 5.0
@export var jump_height : float
@export var jump_time_to_peak : float
@export var jump_time_to_fall : float
@export_range(0.0, 1.0) var friction = 0.1
@export_range(0.0 , 1.0) var acceleration = 0.25
@onready var jump_velocity : float = (2.0 * jump_height) / jump_time_to_peak
@onready var jump_gravity : float = (-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)
@onready var fall_gravity : float = (-2.0 * jump_height) / (jump_time_to_fall * jump_time_to_fall)
@onready var mesh_instance: MeshInstance3D = $MeshInstance3D

# SPEED FUNCTIONS -----------------------------------------------------------------------------------------
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

# FORM FUNCTIONS -----------------------------------------------------------------------------------------
func inside_light(_body: CharacterBody3D):
	form = Form.light
	change_form()
	
func outside_light(_body: CharacterBody3D):
	form = Form.dark
	change_form()

func change_form():
	# Make sure mesh is of correct type
	if mesh_instance and mesh_instance.mesh is CapsuleMesh:
		# Make sure override material is of correct type
		if mesh_instance.get_surface_override_material(0) is StandardMaterial3D:
			var material: StandardMaterial3D = mesh_instance.get_surface_override_material(0) as StandardMaterial3D
			if form == Form.light:
				print("I should be in light mode")
				material.albedo_color = Color("EEEEEE")
			elif form == Form.dark:
				print("I should be in dark mode")
				material.albedo_color = Color("222831")
# PROCESS -----------------------------------------------------------------------------------------
func _ready():
	change_form()

func _physics_process(delta):
	velocity.y += get_gravity() * delta
	
	var input_velocity = get_input_velocity()
	if input_velocity != 0:
		velocity.x = lerp(velocity.x, get_input_velocity() * speed, acceleration)
	else:
		velocity.x = lerp(velocity.x, 0.0, friction)

	if Input.is_action_pressed('jump') and is_on_floor():
		jump()
	
	move_and_slide()
