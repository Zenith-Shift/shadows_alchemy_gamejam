extends Area3D

var entered = false

func _on_body_entered(body: PhysicsBody3D):
	if body.name == "Player":
		entered = true

func _on_body_exited(body: PhysicsBody3D):
	if body.name == "Player" and entered:
		call_deferred("_disable_collision_and_move_camera")

func _disable_collision_and_move_camera():
	$"../Barrier/CollisionShape3D".disabled = false
	$"../Camera3D".position.x = 3.0
