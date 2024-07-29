extends Area3D

func _on_body_entered(_body: CharacterBody3D):
	if $"../White_Door".visible and !$"../Black_Door".visible:
		$"Accept text".visible = true
		if Input.is_action_pressed("enter"):
			print("hello")
			get_tree().change_scene_to_file("res://scenes/base_level_02.tscn")
	elif !$"../White_Door".visible and $"../Black_Door".visible:
		$"Decline text".visible = true

func _on_body_exited(_body:CharacterBody3D):
	$"Accept text".visible = false
	$"Decline text".visible = false

func _process(delta):
	if $"../White_Door".visible and !$"../Black_Door".visible:
		if Input.is_action_pressed("enter"):
			print("hello")
			get_tree().change_scene_to_file("res://scenes/base_level_02.tscn")
