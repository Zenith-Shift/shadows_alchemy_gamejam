extends Area3D

var entered = false

func _on_body_entered(_body: Node3D):
	entered = not entered

func _process(_delta):
	if !entered:
		$"../Camera3D".position.x = 3.0
	else:
		$"../Camera3D".position.x = -13.186
