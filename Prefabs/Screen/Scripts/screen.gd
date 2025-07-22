extends Node3D

@export var current_scan: Scan

var enabled: bool = false

@onready var image = $Image
@onready var title = $Title
@onready var description = $Description

func update_values():
	if current_scan:
		image.texture = current_scan.image
		title.text = current_scan.title
		description.text = current_scan.get_wrapped_description()

func _process(_delta):
	update_values()
	image.visible = enabled and current_scan
	title.visible = enabled and current_scan
	description.visible = enabled and current_scan


#Signal functions
func turn_on():
	enabled = true
func turn_off():
	enabled = false
