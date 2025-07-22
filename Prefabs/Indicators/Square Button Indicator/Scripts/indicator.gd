extends Node3D
class_name Indicator

@export var on: bool = false
@export var flash: bool = false
@export var colour: Color = Color.GREEN

var enabled: bool = true

@onready var diode_on = $Model/Diode_ON
@onready var diode_off = $Model/Diode_OFF

func _ready():
	$Model/Diode_ON/OmniLight3D.light_color = colour
	(diode_on.material_override as StandardMaterial3D).emission = colour

func _process(_delta):
	var flash_time = (not flash) or sin(Time.get_ticks_msec() / 100.0) > 0
	diode_on.visible = on and enabled and flash_time
	diode_off.visible = not on or not enabled or not flash_time

func activate():
	on = true
func deactivate():
	on = false

func turn_on():
	enabled = true
	
func turn_off():
	enabled = false
