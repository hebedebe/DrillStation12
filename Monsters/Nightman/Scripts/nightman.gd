extends Node3D

const APPROACH_TIME = 45.0  # Total dark time needed to trigger appearance
const JUMPSCARE_TIME = 7.0  # Max time player can be in dark when entity is present
const COOLDOWN_TIME = 10.0  # Max time between dark periods to stay present
const MAX_SHAKE_INTENSITY = 0.01

@onready var sprite = $AtWindow/Sprite
@onready var breathing = $AtWindow/Breathing
@onready var stinger = $Stinger
@onready var state_manager = $StateManager
@onready var gamestate: Gamestate

var original_position: Vector3
var cumulative_dark_time = 0.0  # Total time spent in dark
var current_dark_time = 0.0     # Current continuous dark period
var time_since_lights_on = 0.0  # Time since lights came back on
var has_been_seen = false

func _ready():
	gamestate = get_tree().get_first_node_in_group("Gamestate")
	original_position = sprite.position
	state_manager.SetState("NotPresent")

func _process(delta):
	if state_manager.state:
		state_manager.state.Update(delta)

# Helper functions for states
func is_power_off() -> bool:
	return not gamestate.power_manager.power

func get_cumulative_dark_time() -> float:
	return cumulative_dark_time

func add_to_cumulative_dark_time(delta: float):
	cumulative_dark_time += delta

func get_current_dark_time() -> float:
	return current_dark_time

func set_current_dark_time(value: float):
	current_dark_time = value

func increment_current_dark_time(delta: float):
	current_dark_time += delta

func reset_current_dark_time():
	current_dark_time = 0.0

func get_time_since_lights_on() -> float:
	return time_since_lights_on

func increment_time_since_lights_on(delta: float):
	time_since_lights_on += delta

func reset_time_since_lights_on():
	time_since_lights_on = 0.0

func apply_shake():
	var shake_progress = current_dark_time / JUMPSCARE_TIME
	shake_progress = clamp(shake_progress, 0.0, 1.0)
	var intensity = pow(shake_progress, 2) * MAX_SHAKE_INTENSITY
	
	var shake_x = randf_range(-intensity, intensity)
	var shake_y = randf_range(-intensity, intensity)
	var shake_z = randf_range(-intensity, intensity)
	
	sprite.position = original_position + Vector3(shake_x, shake_y, shake_z)

func reset_sprite_position():
	sprite.position = original_position

func check_first_sighting():
	if $VisibleOnScreenNotifier3D.is_on_screen() and sprite.visible and not has_been_seen:
		has_been_seen = true
		stinger.play()
