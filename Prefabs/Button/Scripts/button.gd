extends Node3D

@onready var animation_player = $button/AnimationPlayer
@onready var audio_player = $ButtonPressSound

signal button_interacted

func _on_button_interactor_on_interacted():
	animation_player.speed_scale = 2.0
	animation_player.play("ButtonAction")
	audio_player.play(0.0)
	button_interacted.emit()
