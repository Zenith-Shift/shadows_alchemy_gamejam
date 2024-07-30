extends Node3D

var og_pos
var og_pos_set = false
var player_interacted = false
var player_on_top = false
var form_index

@onready var timer : Timer = $Timer
@onready var player : CharacterBody3D = $"../Player"

func _ready():
	timer.wait_time = 5.0
	if timer:
		timer.connect("timeout", Callable(self, "_on_timer_timeout"))

func _on_tube(player):
	if form_index == 1:
		if not og_pos_set:
			og_pos = self.position.y
			og_pos_set = true
		if player.position.y < self.position.y:
			self.position.y += 0.05
			player_interacted = true
			if !timer.is_stopped():
				timer.stop()
		if player.position.y > self.position.y:
			player_on_top = true
			self.position.y -= 0.005
			player_interacted = true
			if !timer.is_stopped():
				timer.stop()

func _off_tube(player):
#if player.form:
	player_interacted = false
	player_on_top = false
	if timer.is_stopped():
		timer.start()

func _on_timer_timeout():
	if not player_interacted:
		reset_position()

func reset_position():
	if og_pos_set:
		self.position.y = og_pos

func _process(delta):
	form_index = player.form
	if player_on_top:
		self.position.y -= 0.005
	if not player_interacted and timer.time_left == 0:
		reset_position()
