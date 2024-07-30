extends StaticBody3D
@onready var whitedoor = $"../../White_Door"
@onready var blackdoor = $"../../Black_Door"
@onready var anim = $AnimationPlayer

func _on_area_3d_body_entered(_body: CharacterBody3D):
	anim.play("pressdown")
	if whitedoor.visible == false:
		whitedoor.visible = true
		blackdoor.visible = false
	else:
		whitedoor.visible = false
		blackdoor.visible = true


func _on_area_3d_body_exited(_body: CharacterBody3D):
	anim.play("pressup")
