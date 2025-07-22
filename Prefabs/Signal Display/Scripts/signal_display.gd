extends Node3D

@export var freq_dial: Dial
@export var amp_dial: Dial

var enabled: bool = false

@onready var base_display = $SubViewport/Node2D/Base
@onready var input_display = $SubViewport/Node2D/Input

func _ready():
	freq_dial.value_changed.connect(change_freq)
	amp_dial.value_changed.connect(change_amp)

func _process(_delta):
	base_display.visible = enabled
	input_display.visible = enabled

# Signal functions
func change_freq(value):
	input_display.frequency = value
func change_amp(value):
	input_display.amplitude = value
	
func turn_on():
	enabled = true

func turn_off():
	enabled = false
