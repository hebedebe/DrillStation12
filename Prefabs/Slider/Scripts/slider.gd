extends Node3D

@export var min_value: int
@export var max_value: int
@export var distance_range: float

var current_value: int = min_value
var dragging: bool = false

@onready var interactable = $Interactable
@onready var click_sound = $Interactable/ClickSound

signal value_changed(new_value: int)

var viewport: Viewport
var camera: Camera3D

func _ready():
	viewport = get_viewport()
	camera = viewport.get_camera_3d()

func _process(_delta):
	var last_value = current_value
	
	# Logic here #
	if dragging:
		var up_axis = -global_transform.basis.z # z axis vector?
		var min_position_world = global_position + up_axis * -distance_range * 0.5
		var max_position_world = global_position + up_axis * distance_range * 0.5
		var min_pos_scr = camera.unproject_position(min_position_world)
		var max_pos_scr = camera.unproject_position(max_position_world)
		var mouse_position = viewport.get_mouse_position()
		var dial_raw = clamp(inverse_lerp_2d(min_pos_scr, max_pos_scr, mouse_position), 0.0, 1.0)
		current_value = round(lerp(float(min_value), float(max_value), dial_raw))
		interactable.global_position = min_position_world.lerp(max_position_world, dial_raw)
	##############
	
	if current_value != last_value:
		value_changed.emit(current_value)
		click_sound.play()


func inverse_lerp_2d(a: Vector2, b: Vector2, c: Vector2) -> float:
	var ab = b - a
	var ac = c - a
	return ab.dot(ac) / ab.length_squared()


# Signal connections
func _on_interactable_on_interacted():
	dragging = true
func _on_interactable_on_stop_interact():
	dragging = false
