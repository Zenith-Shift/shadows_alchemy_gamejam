extends Area3D

func _on_body_entered(_body: CharacterBody3D):
	$"End Game".visible = true

func _on_body_exited(_body:CharacterBody3D):
	$"End Game".visible = false

func _process(delta):
	if $"End Game".visible:
		if Input.is_action_pressed("enter"):
			print("hello222")
			get_tree().change_scene_to_file("res://scenes/end_screen.tscn")
