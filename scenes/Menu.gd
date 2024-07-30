extends CanvasLayer
@onready var button = $Control/MarginContainer/VBoxContainer/Start

func _process(delta):
	if button.button_pressed == true:
		get_tree().change_scene_to_file("res://base_level.tscn")
