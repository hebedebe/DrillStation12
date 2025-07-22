extends Node3D
class_name Dial

@export var min_value: int = 0
@export var max_value: int = 20
@export var label_text = ""

var value: int = min_value
var dragging: bool = false

@onready var dial = $Model
@onready var label = $Model/DRILL

var viewport: Viewport
var camera: Camera3D

signal value_changed(new_value: int)

func _ready():
	label.text = label_text
	viewport = get_viewport()
	camera = viewport.get_camera_3d()

func _process(_delta):
	var last_value: int = value
	
	if dragging:
		var screen_pos: Vector2 = camera.unproject_position(global_position)
		var difference = screen_pos - viewport.get_mouse_position()
		var direction_to_mouse = atan2(difference.x, difference.y)
		dial.rotation.y = direction_to_mouse
		var angle_deg = fmod(rad_to_deg(direction_to_mouse) + 360.0, 360.0) # Normalize to 0–360
		value = round(lerp(min_value, max_value, 1.0-clamp(angle_deg / 360.0, 0.0, 1.0)))
	
	if last_value != value:
		value_changed.emit(value)
		$ClickSound.play(0.0)

# Signal functions
func _on_interactable_on_interacted():
	dragging = true
func _on_interactable_on_stop_interact():
	dragging = false
