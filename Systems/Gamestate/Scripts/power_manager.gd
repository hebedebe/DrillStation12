extends Node
class_name PowerManager

@export var power: bool

# audio
@onready var power_up_sound = $PowerUp
@onready var power_off_sound = $PowerOff
@onready var power_ambient_sound = $PowerAmbient


# power on/off
func _on_power_lever_on_lever_triggered():
	power = true
	turn_lights_on()
	get_tree().call_group("needs_power", "turn_on")
	power_up_sound.play(0.0)
	power_ambient_sound.play()
	print("Power on")

func _on_power_lever_on_lever_return():
	power = false
	turn_lights_off()
	get_tree().call_group("needs_power", "turn_off")
	power_ambient_sound.stop()
	power_off_sound.play(0.0)
	print("Power off")


# Call groups
func turn_lights_on():
	get_tree().call_group("Lights", "turn_on")

func turn_lights_off():
	get_tree().call_group("Lights", "turn_off")
