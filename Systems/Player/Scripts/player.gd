extends Node3D

@export var look_angle: float = 45.0 # in degrees
@export var breathing_amplitude: float = 0.002
@export var breathing_speed: float = 1.5

const LOOK_SMOOTHING: float = 10.0
const MIN_LOOK_INDEX: int = -1
const MAX_LOOK_INDEX: int = 1
const DEFAULT_LOOK_INDEX = 0
const MOUSE_SENS = 0.00003

var look_index: int = DEFAULT_LOOK_INDEX
var breathing_time: float = 0.0
var been_reset: bool = true

@onready var neck = $Neck
@onready var camera: Camera3D = $Neck/Camera3D
@onready var look_sound: AudioStreamPlayer = $LookSound
@onready var look_left_button: Button = $"Control/Look Left"
@onready var look_right_button: Button = $"Control/Look Right"

func look_left() -> void:
	look_index += 1
	clamp_look_index()

func look_right() -> void:
	look_index -= 1
	clamp_look_index()

func moved() -> void:
	look_sound.play(0.0)

func _process(delta) -> void:
	# Smooth Y rotation
	rotation.y = lerp_angle(rotation.y, get_target_rotation(), LOOK_SMOOTHING * delta)
	
	# Mouse control
	var mouse_pos = get_viewport().get_mouse_position()
	neck.rotation.y = -mouse_pos.x * MOUSE_SENS
	camera.rotation.x = -mouse_pos.y * MOUSE_SENS - 0.001

	# Breathing sway
	breathing_time += delta
	var sway = sin(breathing_time * breathing_speed) * breathing_amplitude
	camera.position.y = sway
	
	look_left_button.visible = (look_index != 1)
	look_right_button.visible = (look_index != -1)

func get_target_rotation() -> float:
	return look_angle * look_index

func clamp_look_index() -> void:
	look_index = clampi(look_index, MIN_LOOK_INDEX, MAX_LOOK_INDEX)

# Signal connections
func _on_look_left_mouse_entered():
	if been_reset:
		been_reset = false
		look_left()
		moved()

func _on_look_right_mouse_entered():
	if been_reset:
		been_reset = false
		look_right()
		moved()

func _on_reset_mouse_entered():
	been_reset = true
