extends Light3D
class_name LightFlicker

@export var default_brightness: float = 1.0
@export var flicker_freq_sin: float = 0.04
@export var flicker_freq_cos: float = 0.025
@export var flicker_amp_sin: float = 0.025
@export var flicker_amp_cos: float = 0.05

var light_on: bool = true

var brightness: float = 1.0

func _process(_delta):
	brightness = (default_brightness + 
		(flicker_amp_sin * sin(flicker_freq_sin * (Time.get_ticks_msec() + global_position.x + global_position.z))) +
		(flicker_amp_cos * sin(flicker_freq_cos * (Time.get_ticks_msec() + global_position.x + global_position.z))))
		
	if not light_on:
		brightness = 0
		
	light_energy = brightness

func turn_on():
	light_on = true
	
func turn_off():
	light_on = false
