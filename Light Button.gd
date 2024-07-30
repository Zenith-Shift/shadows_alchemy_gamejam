extends Area3D
@onready var light = $"../../Lamp/Light"
@onready var collisions = $"../../Lamp/Light/StaticBody3D/CollisionShape3D"
@onready var anim = $AnimationPlayer

func _on_area_3d_body_entered(_body: CharacterBody3D):
	anim.play("pressdown")
	if light.process_mode == light.PROCESS_MODE_INHERIT and light.visible:
		light.visible = false
		light.process_mode = light.PROCESS_MODE_DISABLED
	else:
		light.process_mode = light.PROCESS_MODE_INHERIT
		light.visible = true


func _on_area_3d_body_exited(_body: CharacterBody3D):
	anim.play("pressup")
