extends Node3D

@export var target_dial: Node

var enabled: bool = false

@onready var label = $Model/Screen/Label

func _ready():
	target_dial.value_changed.connect(on_value_changed)
	label.text = ""

func _process(_delta):
	label.visible = enabled
	
func on_value_changed(value: int):
	label.text = str(value)

func turn_on():
	enabled = true

func turn_off():
	enabled = false
