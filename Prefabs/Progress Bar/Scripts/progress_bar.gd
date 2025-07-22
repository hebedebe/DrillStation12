extends Node3D

const START_WIDTH = 0.0
const END_WIDTH = 0.13
const LEFT = -0.103
const RIGHT = 0.0

const MAX_PROGRESS = 1.0

var enabled: bool = false

var progress: float = 0.0

@onready var label = $Label
@onready var loading_bar = $Loadingbar

func _process(_delta):
	label.visible = progress >= MAX_PROGRESS and enabled
	loading_bar.visible = (not (progress >= MAX_PROGRESS)) and enabled
	
	var completion = progress / MAX_PROGRESS
	loading_bar.position.x = lerpf(LEFT, RIGHT, completion)
	loading_bar.scale.x = lerpf(START_WIDTH, END_WIDTH, completion)

# Signal functions
func turn_on():
	enabled = true
func turn_off():
	enabled = false
