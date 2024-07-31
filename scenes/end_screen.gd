extends CanvasLayer
@onready var button = $"Control/MarginContainer/VBoxContainer/END GAME"

func _process(delta):
	if button.button_pressed == true:
		get_tree().change_scene_to_file("res://scenes/Menu.tscn")
